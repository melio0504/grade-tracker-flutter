import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_grade_tracker/l10n/app_localizations.dart';
import 'package:student_grade_tracker/database_helper.dart';
import 'package:student_grade_tracker/screens/home.dart';
import 'package:student_grade_tracker/widgets/bottom_nav.dart';
import 'package:student_grade_tracker/settings_provider.dart';

class AddSubjectScreen extends StatefulWidget {
  const AddSubjectScreen({super.key});

  @override
  State<AddSubjectScreen> createState() => _AddSubjectScreenState();
}

class _AddSubjectScreenState extends State<AddSubjectScreen> {
  final _titleController = TextEditingController();
  final _dbHelper = DatabaseHelper();

  final List<String> _academicImages = [
    'https://images.unsplash.com/photo-1497633762265-9d179a990aa6?q=80&w=400&auto=format&fit=crop', // Books
    'https://images.unsplash.com/photo-1503676260728-1c00da094a0b?q=80&w=400&auto=format&fit=crop', // Education
    'https://images.unsplash.com/photo-1523050335456-c384474b52b7?q=80&w=400&auto=format&fit=crop', // Graduation
    'https://images.unsplash.com/photo-1513475382585-d06e58bcb0e0?q=80&w=400&auto=format&fit=crop', // Library
    'https://images.unsplash.com/photo-1454165833767-02a6ed8a4874?q=80&w=400&auto=format&fit=crop', // Laptop/Study
    'https://images.unsplash.com/photo-1580582932707-520aed937b7b?q=80&w=400&auto=format&fit=crop', // Classroom
  ];

  Future<void> _saveSubject() async {
    final l10n = AppLocalizations.of(context)!;
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.enterSubjectName)),
      );
      return;
    }

    final user = _dbHelper.currentUser;
    if (user == null) return;

    final randomImage = _academicImages[Random().nextInt(_academicImages.length)];

    await _dbHelper.addSubject({
      'userId': user['id'],
      'title': _titleController.text,
      'overallGrade': 0.0,
      'terminalAssessment': 0.0,
      'assignments': 0.0,
      'activity': 0.0,
      'imageUrl': randomImage,
    });

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    final isDark = settings.isDarkMode;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFFAF3E0),
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const HomeScreen()),
                    ),
                    icon: Icon(Icons.arrow_back_ios_new_rounded, color: isDark ? Colors.white : Colors.black),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    l10n.addNewSubject,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.addSubjectDescription,
                    style: TextStyle(fontSize: 16, color: isDark ? Colors.white70 : Colors.black54),
                  ),
                  const SizedBox(height: 40),
                  TextField(
                    controller: _titleController,
                    style: TextStyle(color: isDark ? Colors.white : Colors.black),
                    decoration: InputDecoration(
                      labelText: l10n.subjectName,
                      labelStyle: TextStyle(color: isDark ? Colors.white70 : Colors.black54),
                      hintText: l10n.subjectNameHint,
                      hintStyle: TextStyle(color: isDark ? Colors.white24 : Colors.black26),
                      filled: true,
                      fillColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: isDark ? Colors.white12 : Colors.black12),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: isDark ? Colors.white12 : Colors.black12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(color: Color(0xFF3F78A8), width: 2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: _saveSubject,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDark ? const Color(0xFF3F78A8) : const Color(0xFF5D4037),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        elevation: 5,
                      ),
                      child: Text(
                        l10n.createSubject,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: MediaQuery.of(context).padding.bottom + 10,
            child: const CustomBottomNav(activeTab: 'Add'),
          ),
        ],
      ),
    );
  }
}
