// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get login => 'Login';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get signUp => 'Sign up';

  @override
  String get forgotPassword => 'Forgot Password';

  @override
  String get pleaseFillAllFields => 'Please fill all fields';

  @override
  String get invalidEmailOrPassword => 'Invalid email or password';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get language => 'Language';

  @override
  String get privacy => 'Privacy';

  @override
  String get help => 'Help';

  @override
  String get about => 'About';

  @override
  String get logout => 'Log out';

  @override
  String get deleteAccount => 'Delete Account';

  @override
  String get deleteAccountConfirm =>
      'Are you sure you want to delete your account? This action cannot be undone.';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get privacyPolicy =>
      'All information is only in your local storage and nothing is sending out the information.';

  @override
  String get helpContent =>
      'Please send email for support: \"423002722@ntc.edu.ph\"';

  @override
  String get aboutContent =>
      'Advanced Mobile Development \nMade for Terminal Assessment 1\n\nTeam Leader / Coordinator \nCerna, Reymartin Angelo I.\n\nUI/UX Designer\nDacles, Pearl Diane J.\n\nState Management Developer\nTeodoro, Romelio C.\n\nFrontend Developer\nRivera, Edmon Daniel C.\n\nDocumentation / Reporter\nBasit, Krizandra Josephine L.\n\n3.3BSIT\n03/10/26';

  @override
  String get fullName => 'Full Name';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get agreeToTerms => 'I have agreed on the terms and conditions';

  @override
  String get agreeToTermsError => 'Please agree to terms and conditions';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get registrationSuccessful => 'Registration successful!';

  @override
  String get registrationFailed =>
      'Registration failed. Email might already exist.';

  @override
  String get backToLogin => 'Back to Login';

  @override
  String get myGrades => 'My Grades';

  @override
  String get overallGrade => 'Overall grade';

  @override
  String get terminalAssessments => 'Terminal Assessments';

  @override
  String get assignments => 'Assignments';

  @override
  String get activity => 'Activity';

  @override
  String get noSubjectYet => 'No Subject Yet';

  @override
  String get addSubjectSubtitle =>
      'Add a new subject to insert new subject card here';

  @override
  String get recent => 'Recent';

  @override
  String get noRecentTasks => 'No recent tasks';

  @override
  String get editSubjectName => 'Edit Subject Name';

  @override
  String get subjectName => 'Subject Name';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get deleteSubject => 'Delete Subject';

  @override
  String deleteSubjectConfirm(String title) {
    return 'Are you sure you want to delete \"$title\"? This will also delete all its activities.';
  }

  @override
  String get delete => 'Delete';

  @override
  String get newActivity => 'New Activity';

  @override
  String get editActivity => 'Edit Activity';

  @override
  String get type => 'Type';

  @override
  String get terminalAssessmentsSingle => 'Terminal Assessment';

  @override
  String get assignmentsSingle => 'Assignment';

  @override
  String get activityName => 'Activity Name';

  @override
  String get description => 'Description';

  @override
  String get gradePercent => 'Grade (%)';

  @override
  String get dueDate => 'Due Date';

  @override
  String get completed => 'Completed';

  @override
  String get edit => 'Edit';

  @override
  String get markAsFinished => 'Mark as Finished';

  @override
  String get pending => 'pending';

  @override
  String get emptyOverallWarning => 'Empty overall. Add a new Activity!';

  @override
  String get tasksDueTime => 'Tasks & Due Time:';

  @override
  String get noPendingTasks => 'No pending tasks';

  @override
  String get totalGrading => 'Total Grading';

  @override
  String get addNewSubject => 'Add New Subject';

  @override
  String get addSubjectDescription =>
      'Enter the name of the subject you want to track.';

  @override
  String get subjectNameHint => 'e.g. Mathematics, History, Art';

  @override
  String get createSubject => 'Create Subject';

  @override
  String get enterSubjectName => 'Please enter a subject name';

  @override
  String get navHome => 'Home';

  @override
  String get navAdd => 'Add';

  @override
  String get navProfile => 'Profile';
}
