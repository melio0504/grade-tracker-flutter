import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_grade_tracker/database_helper.dart';
import 'package:student_grade_tracker/screens/subject.dart';
import 'package:student_grade_tracker/settings_provider.dart';
import 'package:student_grade_tracker/widgets/bottom_nav.dart';
import 'package:student_grade_tracker/l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> _subjects = [];
  Map<int, List<Map<String, dynamic>>> _subjectActivities = {};
  bool _isLoading = true;

  final List<String> _academicThumbnails = [
    'https://images.unsplash.com/photo-1497633762265-9d179a990aa6?w=400&q=80', // Books
    'https://images.unsplash.com/photo-1456513080510-7bf3a84b82f8?w=400&q=80', // Library
    'https://images.unsplash.com/photo-1503676260728-1c00da094a0b?w=400&q=80', // Classroom
    'https://images.unsplash.com/photo-1516979187457-637abb4f9353?w=400&q=80', // Scientific
    'https://images.unsplash.com/photo-1509062522246-3755977927d7?w=400&q=80', // Chalkboard
    'https://images.unsplash.com/photo-1434030216411-0b793f4b4173?w=400&q=80', // Writing
    'https://images.unsplash.com/photo-1513258496099-48168024aec0?w=400&q=80', // Study
    'https://images.unsplash.com/photo-1524995997946-a1c2e315a42f?w=400&q=80', // Shelves
    'https://images.unsplash.com/photo-1491841573634-28140fc7ced7?w=400&q=80', // Notebook
    'https://images.unsplash.com/photo-1510172951991-859a69c43f75?w=400&q=80', // Workspace
    'https://images.unsplash.com/photo-1523240795612-9a054b0db644?w=400&q=80', // Students
    'https://images.unsplash.com/photo-1521737604893-d14cc237f11d?w=400&q=80', // Teamwork
    'https://images.unsplash.com/photo-1495446815901-a7297e633e8d?w=400&q=80', // More books
    'https://images.unsplash.com/photo-1516321318423-f06f85e504b3?w=400&q=80', // Digital learning
    'https://images.unsplash.com/photo-1532012197267-da84d127e765?w=400&q=80', // Open book
    'https://images.unsplash.com/photo-1546410531-bb4caa6b424d?w=400&q=80', // Graduation
    'https://images.unsplash.com/photo-1517842645767-c639042777db?w=400&q=80', // Notebook/Coffee
    'https://images.unsplash.com/photo-1513542789411-b6a5d4f31634?w=400&q=80', // Pencils
    'https://images.unsplash.com/photo-1454165833767-027ffeb99c17?w=400&q=80', // Laptop/Work
    'https://images.unsplash.com/photo-1522202176988-66273c2fd55f?w=400&q=80', // Collaboration
    'https://images.unsplash.com/photo-1531482615713-2afd69097998?w=400&q=80', // Learning context
    'https://images.unsplash.com/photo-1498243639311-f3b07df1e45f?w=400&q=80', // University building
    'https://images.unsplash.com/photo-1488190211105-8b0e65b80b4e?w=400&q=80', // Writing pad
    'https://images.unsplash.com/photo-1501504905252-473c47e087f8?w=400&q=80', // Study space
    'https://images.unsplash.com/photo-1491841550275-ad7854e35ca6?w=400&q=80', // Back to school
    'https://images.unsplash.com/photo-1501139083538-0139583c060f?w=400&q=80', // Clock/Time
    'https://images.unsplash.com/photo-1427504494785-3a9ca7044f45?w=400&q=80', // Campus
    'https://images.unsplash.com/photo-1519389950473-47ba0277781c?w=400&q=80', // Tech/Coding
    'https://images.unsplash.com/photo-1432888498266-38ffec3eaf0a?w=400&q=80', // Work/Study
    'https://images.unsplash.com/photo-1507537297725-24a1c029d3ca?w=400&q=80', // Thinking
    'https://images.unsplash.com/photo-1494599948593-3dafe8338d71?w=400&q=80', // Organized desk
    'https://images.unsplash.com/photo-1453749024858-4bca89bd9edc?w=400&q=80', // Microscope
    'https://images.unsplash.com/photo-1506377711776-dbdc2f3c20d9?w=400&q=80', // Design/Art
    'https://images.unsplash.com/photo-1516534775068-ba3e7458af70?w=400&q=80', // Research
    'https://images.unsplash.com/photo-1523050854058-8df90110c9f1?w=400&q=80', // University hall
    'https://images.unsplash.com/photo-1524178232363-1fb2b075b655?w=400&q=80', // Lecture theatre
    'https://images.unsplash.com/photo-1481627834876-b7833e8f5570?w=400&q=80', // Library aisle
    'https://images.unsplash.com/photo-1519452635265-7b1fbfd1e4e0?w=400&q=80', // School corridor
    'https://images.unsplash.com/photo-1503919219737-6762b699bbd9?w=400&q=80', // Pile of books
    'https://images.unsplash.com/photo-1588072432836-e10032774350?w=400&q=80', // Primary school
    'https://images.unsplash.com/photo-1541339907198-e08756ebafe3?w=400&q=80', // University architecture
    'https://images.unsplash.com/photo-1525921429624-479b6a29d84c?w=400&q=80', // Campus life
    'https://images.unsplash.com/photo-1517694712202-14dd9538aa97?w=400&q=80', // Coding laptop
    'https://images.unsplash.com/photo-1497015289639-54688650d173?w=400&q=80', // Modern study
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final user = _dbHelper.currentUser;
    if (user == null) {
      if (mounted) setState(() => _isLoading = false);
      return;
    }
    setState(() => _isLoading = true);
    final subjects = await _dbHelper.getSubjects(user['id']);
    final Map<int, List<Map<String, dynamic>>> activitiesMap = {};
    
    for (var subject in subjects) {
      final activities = await _dbHelper.getActivities(subject['id']);
      activitiesMap[subject['id']] = activities;
    }

    if (mounted) {
      setState(() {
        _subjects = subjects;
        _subjectActivities = activitiesMap;
        _isLoading = false;
      });
    }
  }

  double _calculateGlobalOverallGrade() {
    int totalCount = 0;
    double totalGrade = 0;

    _subjectActivities.forEach((subjectId, activities) {
      for (var activity in activities) {
        if (activity['grade'] != null) {
          totalGrade += activity['grade'];
          totalCount++;
        }
      }
    });

    return totalCount > 0 ? totalGrade / totalCount : 0.0;
  }

  double _calculateGlobalAverageByType(String type) {
    int totalCount = 0;
    double totalGrade = 0;

    _subjectActivities.forEach((subjectId, activities) {
      for (var activity in activities) {
        if (activity['type'] == type && activity['grade'] != null) {
          totalGrade += activity['grade'];
          totalCount++;
        }
      }
    });

    return totalCount > 0 ? (totalGrade / totalCount) / 100 : 0.0;
  }

  String _getRecentAssignment(int subjectId) {
    final l10n = AppLocalizations.of(context)!;
    final activities = _subjectActivities[subjectId] ?? [];
    if (activities.isEmpty) return l10n.noRecentTasks;
    
    final recent = activities.last;
    return '${l10n.recent}: ${recent['name']} - ${recent['dueDate']}';
  }

  void _showEditSubjectDialog(Map<String, dynamic> subject) {
    final l10n = AppLocalizations.of(context)!;
    final nameController = TextEditingController(text: subject['title']);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.editSubjectName),
        content: TextField(
          controller: nameController,
          decoration: InputDecoration(labelText: l10n.subjectName),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(l10n.cancel)),
          ElevatedButton(
            onPressed: () async {
              if (nameController.text.isNotEmpty) {
                await _dbHelper.updateSubject(subject['id'], {'title': nameController.text});
                if (mounted) {
                  Navigator.pop(context);
                  _loadData();
                }
              }
            },
            child: Text(l10n.save),
          ),
        ],
      ),
    );
  }

  void _showSubjectOptions(Map<String, dynamic> subject) {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.edit),
            title: Text(l10n.editSubjectName),
            onTap: () {
              Navigator.pop(context);
              _showEditSubjectDialog(subject);
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete, color: Colors.red),
            title: Text(l10n.deleteSubject),
            onTap: () {
              Navigator.pop(context);
              _confirmDeleteSubject(subject);
            },
          ),
        ],
      ),
    );
  }

  void _confirmDeleteSubject(Map<String, dynamic> subject) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteSubject),
        content: Text(l10n.deleteSubjectConfirm(subject['title'] ?? 'Untitled')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(l10n.cancel)),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              await _dbHelper.deleteSubject(subject['id']);
              if (mounted) {
                Navigator.pop(context);
                _loadData();
              }
            },
            child: Text(l10n.delete, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  String _getAcademicImage(int index) {
    return _academicThumbnails[index % _academicThumbnails.length];
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    final isDark = settings.isDarkMode;
    final l10n = AppLocalizations.of(context)!;
    final user = _dbHelper.currentUser;
    final overallGrade = _calculateGlobalOverallGrade();
    final terminalAvg = _calculateGlobalAverageByType('Terminal Assessment');
    final assignmentsAvg = _calculateGlobalAverageByType('Assignment');
    final activityAvg = _calculateGlobalAverageByType('Activity');

    String formattedId = "N/A";
    if (user != null) {
      final seed = user['id'] as int;
      final random = Random(seed);
      final randomNum = 10000 + random.nextInt(90000); // 5-digit random number
      formattedId = "${DateTime.now().year}-$randomNum";
    }

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFFAF3E0),
      body: Stack(
        children: [
          Positioned.fill(
            child: SafeArea(
              bottom: false,
              child: _isLoading 
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: _loadData,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.myGrades,
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black,
                            ),
                          ),
                          Text(
                            'ID: $formattedId',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.blueAccent,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: isDark ? const Color(0xFF2C2C2C) : const Color(0xFFC7B7A3),
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(color: isDark ? Colors.white24 : Colors.black, width: 1),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.2),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 20),
                                    decoration: BoxDecoration(
                                      color: isDark ? const Color(0xFF333333) : Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Column(
                                      children: [
                                        Text(
                                          l10n.overallGrade,
                                          style: TextStyle(fontSize: 14, color: isDark ? Colors.white70 : Colors.black54),
                                        ),
                                        const SizedBox(height: 12),
                                        Text(
                                          _subjectActivities.isEmpty || _calculateGlobalOverallGrade() == 0 ? '-%' : '${overallGrade.toStringAsFixed(0)}%',
                                          style: TextStyle(
                                            fontSize: 40,
                                            fontWeight: FontWeight.bold,
                                            color: isDark ? Colors.white : Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: isDark ? const Color(0xFF333333) : Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        _buildProgressBar(l10n.terminalAssessments, terminalAvg, isDark),
                                        const SizedBox(height: 8),
                                        _buildProgressBar(l10n.assignments, assignmentsAvg, isDark),
                                        const SizedBox(height: 8),
                                        _buildProgressBar(l10n.activity, activityAvg, isDark),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 30),
                          if (_subjects.isEmpty)
                            _buildSubjectCard(
                              title: l10n.noSubjectYet,
                              subtitle: l10n.addSubjectSubtitle,
                              isPlaceholder: true,
                              onTap: () {},
                              isDark: isDark,
                            )
                          else
                            ..._subjects.asMap().entries.map((entry) {
                              final index = entry.key;
                              final subject = entry.value;
                              return Column(
                                children: [
                                  _buildSubjectCard(
                                    title: subject['title'] ?? 'Untitled',
                                    imageUrl: subject['imageUrl'] ?? _getAcademicImage(index),
                                    subtitle: _getRecentAssignment(subject['id']),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => SubjectScreen(
                                            subject: subject,
                                          ),
                                        ),
                                      ).then((_) => _loadData());
                                    },
                                    onLongPress: () => _showSubjectOptions(subject),
                                    isDark: isDark,
                                  ),
                                  const SizedBox(height: 15),
                                ],
                              );
                            }),
                          const SizedBox(height: 100),
                        ],
                      ),
                    ),
                  ),
            ),
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: MediaQuery.of(context).padding.bottom + 10,
            child: const CustomBottomNav(activeTab: 'Home'),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(String label, double value, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 12, color: isDark ? Colors.white70 : Colors.black54),
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: value,
            backgroundColor: isDark ? Colors.white12 : Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(isDark ? Colors.white : const Color(0xFF3F78A8)),
            minHeight: 6,
          ),
        ),
      ],
    );
  }

  Widget _buildSubjectCard({
    required String title,
    String? imageUrl,
    required String subtitle,
    bool isPlaceholder = false,
    required VoidCallback onTap,
    VoidCallback? onLongPress,
    required bool isDark,
  }) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2C2C2C) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: isDark ? Colors.white10 : const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(15),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: isPlaceholder
                  ? Icon(
                      Icons.add_circle_outline,
                      size: 30,
                      color: isDark ? Colors.white30 : Colors.grey[400],
                    )
                  : Image.network(
                      imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Icon(
                        Icons.book_outlined,
                        size: 30,
                        color: isDark ? Colors.white30 : Colors.grey[400],
                      ),
                    ),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? Colors.white54 : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: isDark ? Colors.white24 : Colors.grey[300],
            ),
          ],
        ),
      ),
    );
  }
}
