import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/classroom/v1.dart';
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'database_helper.dart';

class GoogleClassroomService {
  // Use the Web Client ID from your google-services.json or Google Cloud Console.
  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    serverClientId: '756388512754-9uojlb6hrefoilvk34jt5pqdlf67grhl.apps.googleusercontent.com',
    scopes: [
      'email',
      'profile',
      ClassroomApi.classroomCoursesReadonlyScope,
      ClassroomApi.classroomCourseworkMeReadonlyScope,
      ClassroomApi.classroomStudentSubmissionsMeReadonlyScope,
    ],
  );

  static Future<GoogleSignInAccount?> signIn() async {
    try {
      print('Google Sign-In: Starting sign-in process...');
      
      // Try to sign in silently first if the user has already granted access
      var account = await _googleSignIn.signInSilently();
      
      if (account == null) {
        // If silent sign-in fails, prompt the user to choose an account
        account = await _googleSignIn.signIn();
      }
      
      if (account == null) {
        print('Google Sign-In: Sign-in returned null (User cancelled or Config error)');
      } else {
        print('Google Sign-In: Successful! ${account.email}');
      }
      
      return account;
    } catch (error) {
      print('--- GOOGLE SIGN-IN ERROR ---');
      print(error);
      print('---------------------------');
      rethrow;
    }
  }

  static Future<void> syncClassroomData(int userId) async {
    try {
      final authClient = await _googleSignIn.authenticatedClient();
      if (authClient == null) {
        throw Exception('Failed to obtain authenticated client. Did you grant all permissions?');
      }

      final classroomApi = ClassroomApi(authClient);
      final dbHelper = DatabaseHelper();

      print('Google Classroom: Fetching active enrolled courses...');
      // Fetch only ACTIVE courses where the user is a student
      final coursesResponse = await classroomApi.courses.list(
        courseStates: ['ACTIVE'],
        studentId: 'me',
      );
      final courses = coursesResponse.courses ?? [];

      if (courses.isEmpty) {
        print('Google Classroom: No active enrolled courses found.');
        return;
      }

      // Optimization: Fetch existing subjects once
      final existingSubjects = await dbHelper.getSubjects(userId);

      for (var course in courses) {
        if (course.id == null || course.name == null) continue;

        var subjectId = -1;
        final matches = existingSubjects.where((s) => s['title'] == course.name);
        final existingSubject = matches.isNotEmpty ? matches.first : null;
        
        if (existingSubject == null) {
          subjectId = await dbHelper.addSubject({
            'userId': userId,
            'title': course.name,
            'overallGrade': 0.0,
            'terminalAssessment': 0.0,
            'assignments': 0.0,
            'activity': 0.0,
            'imageUrl': null,
          });
          print('Added subject: ${course.name}');
        } else {
          subjectId = existingSubject['id'];
        }

        try {
          print('Fetching coursework and submissions for course: ${course.name}');
          
          // Fetch only PUBLISHED coursework
          final courseworkResponse = await classroomApi.courses.courseWork.list(
            course.id!,
            courseWorkStates: ['PUBLISHED'],
          );
          final coursework = courseworkResponse.courseWork ?? [];

          // Fetch all student submissions for this user in this course
          final submissionsResponse = await classroomApi.courses.courseWork.studentSubmissions.list(
            course.id!,
            '-', // All coursework items
            userId: 'me',
          );
          final submissions = submissionsResponse.studentSubmissions ?? [];
          
          // Map courseworkId -> submission for easy lookup
          final submissionMap = {for (var s in submissions) s.courseWorkId: s};

          // Optimization: Fetch existing activities for this subject once
          final existingActivities = await dbHelper.getActivities(subjectId);
          final existingActivityMap = {for (var a in existingActivities) a['name'] as String: a};

          for (var work in coursework) {
            if (work.id == null || work.title == null) continue;
            
            // Filter: Only sync "Assignments" as requested
            // We can also include Questions if they are considered "assignments" by the user
            if (work.workType != 'ASSIGNMENT' && 
                work.workType != 'SHORT_ANSWER_QUESTION' && 
                work.workType != 'MULTIPLE_CHOICE_QUESTION') {
              continue;
            }

            String type = 'Activity';
            if (work.workType == 'ASSIGNMENT') {
              type = 'Assignment';
            }

            // Get submission info
            final submission = submissionMap[work.id];
            double grade = 0.0;
            int isCompleted = 0;

            if (submission != null) {
              // assignedGrade is the final grade returned to the student
              grade = submission.assignedGrade ?? 0.0;
              
              // Map states to isCompleted
              // Possible states: NEW, CREATED, TURNED_IN, RETURNED, RECLAIMED_BY_STUDENT
              if (submission.state == 'TURNED_IN' || submission.state == 'RETURNED') {
                isCompleted = 1;
              }
            }

            final activityData = {
              'subjectId': subjectId,
              'name': work.title,
              'description': work.description ?? '',
              'grade': grade,
              'isCompleted': isCompleted,
              'dueDate': work.dueDate != null 
                  ? '${work.dueDate!.year}-${work.dueDate!.month}-${work.dueDate!.day}'
                  : 'No due date',
              'type': type,
            };

            final existing = existingActivityMap[work.title];
            if (existing != null) {
              // Update if changed (Syncing updates)
              if (existing['grade'] != grade || 
                  existing['isCompleted'] != isCompleted ||
                  existing['dueDate'] != activityData['dueDate']) {
                await dbHelper.updateActivity(existing['id'], activityData);
                print('Updated activity: ${work.title}');
              }
            } else {
              await dbHelper.addActivity(activityData);
              print('Added activity: ${work.title}');
            }
          }
        } catch (e) {
          print('Error syncing coursework for course ${course.name}: $e');
          // Continue to next course even if one fails
        }
      }
      print('Google Classroom: Sync completed.');
    } catch (e) {
      print('Critical error syncing Google Classroom data: $e');
      rethrow;
    }
  }
}
