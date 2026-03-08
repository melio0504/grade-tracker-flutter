import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_grade_tracker/l10n/app_localizations.dart';
import 'package:student_grade_tracker/database_helper.dart';
import 'package:student_grade_tracker/widgets/bottom_nav.dart';
import 'package:student_grade_tracker/settings_provider.dart';
import 'package:intl/intl.dart';

class SubjectScreen extends StatefulWidget {
  final Map<String, dynamic> subject;
  const SubjectScreen({super.key, required this.subject});

  @override
  State<SubjectScreen> createState() => _SubjectScreenState();
}

class _SubjectScreenState extends State<SubjectScreen> {
  final _dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> _activities = [];
  bool _isLoading = true;

  final List<IconData> _academicIcons = [
    Icons.book,
    Icons.school,
    Icons.assignment,
    Icons.laptop_chromebook,
    Icons.edit_note,
    Icons.science,
    Icons.calculate,
    Icons.menu_book,
    Icons.history_edu,
    Icons.auto_stories,
    Icons.biotech,
    Icons.draw,
  ];

  @override
  void initState() {
    super.initState();
    _loadActivities();
  }

  Future<void> _loadActivities() async {
    final activities = await _dbHelper.getActivities(widget.subject['id']);
    setState(() {
      _activities = activities;
      _isLoading = false;
    });
  }

  double _calculateOverallGrade() {
    if (_activities.isEmpty) return 0.0;
    double total = 0;
    int count = 0;
    for (var activity in _activities) {
      if (activity['grade'] != null) {
        total += activity['grade'];
        count++;
      }
    }
    return count > 0 ? total / count : 0.0;
  }

  Map<String, dynamic>? _getNextDueActivity() {
    for (var activity in _activities) {
      if (activity['isCompleted'] == 0) {
        return activity;
      }
    }
    return null;
  }

  IconData _getIconForActivity(Map<String, dynamic> activity) {
    final name = (activity['name'] ?? '').toString().toLowerCase();
    
    if (name.contains('exam') || name.contains('test') || name.contains('quiz')) return Icons.quiz;
    if (name.contains('lab') || name.contains('experiment')) return Icons.science;
    if (name.contains('essay') || name.contains('write') || name.contains('paper')) return Icons.history_edu;
    if (name.contains('code') || name.contains('programming')) return Icons.code;
    if (name.contains('math') || name.contains('calculate')) return Icons.calculate;
    if (name.contains('art') || name.contains('draw') || name.contains('design')) return Icons.palette;
    if (name.contains('read') || name.contains('book')) return Icons.menu_book;
    if (name.contains('project')) return Icons.account_tree;
    if (name.contains('homework')) return Icons.home_work;
    if (name.contains('group') || name.contains('team')) return Icons.groups;

    int index = (activity['id'] ?? activity['name'].hashCode).abs() % _academicIcons.length;
    return _academicIcons[index];
  }

  void _showActivityDialog({Map<String, dynamic>? activity}) {
    final l10n = AppLocalizations.of(context)!;
    final nameController = TextEditingController(text: activity?['name'] ?? '');
    final gradeController = TextEditingController(text: activity?['grade']?.toString() ?? '');
    final descController = TextEditingController(text: activity?['description'] ?? '');
    final dateController = TextEditingController(text: activity?['dueDate'] ?? DateFormat('MMM dd').format(DateTime.now()));
    
    String selectedType = activity?['type'] ?? 'Activity';
    bool isCompleted = (activity?['isCompleted'] ?? 0) == 1;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(activity == null ? l10n.newActivity : l10n.editActivity),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  value: selectedType,
                  decoration: InputDecoration(labelText: l10n.type),
                  items: {
                    'Terminal Assessment': l10n.terminalAssessmentsSingle,
                    'Assignment': l10n.assignmentsSingle,
                    'Activity': l10n.activity,
                  }.entries.map((e) => DropdownMenuItem<String>(
                        value: e.key,
                        child: Text(e.value),
                      )).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setDialogState(() => selectedType = value);
                    }
                  },
                ),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: l10n.activityName),
                ),
                TextField(
                  controller: descController,
                  decoration: InputDecoration(labelText: l10n.description),
                ),
                TextField(
                  controller: gradeController,
                  decoration: InputDecoration(labelText: l10n.gradePercent),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: dateController,
                  decoration: InputDecoration(
                    labelText: l10n.dueDate,
                    suffixIcon: const Icon(Icons.calendar_today),
                  ),
                  readOnly: true,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null) {
                      setDialogState(() {
                        dateController.text = DateFormat('MMM dd').format(pickedDate);
                      });
                    }
                  },
                ),
                CheckboxListTile(
                  title: Text(l10n.completed),
                  value: isCompleted,
                  onChanged: (val) => setDialogState(() => isCompleted = val ?? false),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text(l10n.cancel)),
            ElevatedButton(
              onPressed: () async {
                final data = {
                  'subjectId': widget.subject['id'],
                  'name': nameController.text,
                  'description': descController.text,
                  'grade': double.tryParse(gradeController.text) ?? 0.0,
                  'isCompleted': isCompleted ? 1 : 0,
                  'dueDate': dateController.text,
                  'type': selectedType,
                };

                if (activity == null) {
                  await _dbHelper.addActivity(data);
                } else {
                  await _dbHelper.updateActivity(activity['id'], data);
                }
                
                if (mounted) {
                  Navigator.pop(context);
                  _loadActivities();
                }
              },
              child: Text(l10n.save),
            ),
          ],
        ),
      ),
    );
  }

  void _showOptionsPopup(Map<String, dynamic> activity) {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.edit),
            title: Text(l10n.edit),
            onTap: () {
              Navigator.pop(context);
              _showActivityDialog(activity: activity);
            },
          ),
          ListTile(
            leading: const Icon(Icons.check_circle, color: Colors.green),
            title: Text(l10n.markAsFinished),
            onTap: () async {
              await _dbHelper.updateActivity(activity['id'], {...activity, 'isCompleted': 1});
              if (mounted) {
                Navigator.pop(context);
                _loadActivities();
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete, color: Colors.red),
            title: Text(l10n.delete),
            onTap: () async {
              await _dbHelper.deleteActivity(activity['id']);
              if (mounted) {
                Navigator.pop(context);
                _loadActivities();
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    final isDark = settings.isDarkMode;
    final l10n = AppLocalizations.of(context)!;
    final nextActivity = _getNextDueActivity();
    final overallGrade = _calculateOverallGrade();

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFFAF3E0),
      body: Stack(
        children: [
          Positioned.fill(
            child: SafeArea(
              bottom: false,
              child: _isLoading 
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back, color: isDark ? Colors.white : Colors.black),
                          onPressed: () => Navigator.pop(context),
                        ),
                        Expanded(
                          child: Text(
                            widget.subject['title'] ?? 'Subject',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),

                    _buildGradeSummaryCard(overallGrade, nextActivity, isDark),
                    const SizedBox(height: 30),

                    if (_activities.isEmpty)
                      _buildEmptyWarning(isDark)
                    else
                      ..._activities.map((activity) => Column(
                        children: [
                          GestureDetector(
                            onLongPress: () => _showOptionsPopup(activity),
                            child: _buildTaskCard(
                              grading: activity['grade'] != null ? '${activity['grade']}%' : l10n.pending,
                              taskName: activity['name'] ?? 'Task',
                              isCompleted: activity['isCompleted'] == 1,
                              icon: _getIconForActivity(activity),
                              isDark: isDark,
                            ),
                          ),
                          const SizedBox(height: 15),
                        ],
                      )),

                    const SizedBox(height: 120),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: MediaQuery.of(context).padding.bottom + 10,
            child: CustomBottomNav(
              activeTab: '',
              onAddTap: () => _showActivityDialog(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyWarning(bool isDark) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2C2C2C) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.orangeAccent),
      ),
      child: Column(
        children: [
          const Icon(Icons.warning_amber_rounded, size: 48, color: Colors.orangeAccent),
          const SizedBox(height: 10),
          Text(
            l10n.emptyOverallWarning,
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.orange),
          ),
        ],
      ),
    );
  }

  Widget _buildGradeSummaryCard(double overall, Map<String, dynamic>? next, bool isDark) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2C2C2C) : const Color(0xFFC7B7A3),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: isDark ? Colors.white24 : Colors.black, width: 1),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 140,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF333333) : Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.overallGrade, style: TextStyle(fontSize: 12, color: isDark ? Colors.white70 : Colors.black54)),
                  Expanded(
                    child: Center(
                      child: Text(
                        _activities.isEmpty ? '-%' : '${overall.toStringAsFixed(0)}%',
                        style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              height: 140,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF333333) : Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.tasksDueTime, style: TextStyle(fontSize: 12, color: isDark ? Colors.white70 : Colors.black54)),
                  const SizedBox(height: 8),
                  if (next != null)
                    Text(
                      '${next['name']} - ${next['dueDate']}',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: isDark ? Colors.white : Colors.black),
                    )
                  else
                    Text(l10n.noPendingTasks, style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: isDark ? Colors.white38 : Colors.black54)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskCard({
    required String grading,
    required String taskName,
    required IconData icon,
    required bool isDark,
    bool isCompleted = false,
  }) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2C2C2C) : Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: isDark ? Colors.white12 : Colors.black, width: 0.8),
      ),
      child: Column(
        children: [
          Container(
            height: 140,
            width: double.infinity,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF382E3C) : const Color(0xFFF3E5F5),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
            ),
            child: Stack(
              children: [
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: (isDark ? Colors.white : Colors.black).withOpacity(0.05),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, size: 60, color: isDark ? Colors.white38 : Colors.black38),
                  ),
                ),
                Positioned(
                  top: 15,
                  left: 15,
                  right: 50,
                  child: Text(
                    taskName,
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis,
                    ),
                    maxLines: 1,
                  ),
                ),
                if (isCompleted)
                  const Positioned(
                    top: 10,
                    right: 10,
                    child: Icon(Icons.check_circle, color: Colors.green, size: 30),
                  ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(border: Border(top: BorderSide(color: isDark ? Colors.white12 : Colors.black, width: 0.5))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${l10n.totalGrading}: $grading', 
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: isDark ? Colors.white70 : Colors.black87)
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
