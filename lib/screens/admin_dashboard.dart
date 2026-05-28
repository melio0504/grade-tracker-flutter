import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_grade_tracker/database_helper.dart';
import 'package:student_grade_tracker/settings_provider.dart';
import 'package:student_grade_tracker/l10n/app_localizations.dart';
import 'signup.dart'; // Reuse for adding user if needed, or create a specific form

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> _users = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    setState(() => _isLoading = true);
    final users = await _dbHelper.getAllUsers();
    setState(() {
      _users = users;
      _isLoading = false;
    });
  }

  void _deleteUser(int userId) async {
    final l10n = AppLocalizations.of(context)!;
    bool? confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete User"),
        content: const Text("Are you sure you want to delete this user and all their data?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(l10n.cancel)),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.delete, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _dbHelper.deleteUser(userId);
      _loadUsers();
    }
  }

  void _editUser(Map<String, dynamic> user) {
    _showUserForm(user: user);
  }

  void _showUserForm({Map<String, dynamic>? user}) {
    final isEditing = user != null;
    final firstNameController = TextEditingController(text: user?['firstName'] ?? '');
    final middleNameController = TextEditingController(text: user?['middleName'] ?? '');
    final lastNameController = TextEditingController(text: user?['lastName'] ?? '');
    final emailController = TextEditingController(text: user?['email'] ?? '');
    final studentIdController = TextEditingController(text: user?['studentId'] ?? '');
    final gradeLevelController = TextEditingController(text: user?['gradeLevel'] ?? '');
    final sectionController = TextEditingController(text: user?['section'] ?? '');
    final passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEditing ? "Edit User" : "Add New User"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: firstNameController, decoration: const InputDecoration(labelText: "First Name")),
              TextField(controller: middleNameController, decoration: const InputDecoration(labelText: "Middle Name")),
              TextField(controller: lastNameController, decoration: const InputDecoration(labelText: "Last Name")),
              TextField(controller: emailController, decoration: const InputDecoration(labelText: "Email")),
              TextField(controller: studentIdController, decoration: const InputDecoration(labelText: "Student ID")),
              TextField(controller: gradeLevelController, decoration: const InputDecoration(labelText: "Grade Level")),
              TextField(controller: sectionController, decoration: const InputDecoration(labelText: "Section")),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: isEditing ? "New Password (leave empty to keep current)" : "Password",
                  hintText: !isEditing ? "Default: DefaultPassword123!" : null,
                ),
                obscureText: true,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () async {
              String email = emailController.text.trim();
              if (email.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Email is required")));
                return;
              }

              try {
                if (isEditing) {
                  Map<String, dynamic> data = {
                    'firstName': firstNameController.text.trim(),
                    'middleName': middleNameController.text.trim(),
                    'lastName': lastNameController.text.trim(),
                    'email': email,
                    'studentId': studentIdController.text.trim(),
                    'gradeLevel': gradeLevelController.text.trim(),
                    'section': sectionController.text.trim(),
                    'username': '${firstNameController.text.trim()} ${lastNameController.text.trim()}',
                  };
                  if (passwordController.text.isNotEmpty) {
                    data['password'] = passwordController.text;
                  }
                  await _dbHelper.updateUser(user['id'], data);
                } else {
                  String password = passwordController.text;
                  if (password.isEmpty) {
                    password = 'DefaultPassword123!';
                  }

                  await _dbHelper.registerUser(
                    firstName: firstNameController.text.trim(),
                    middleName: middleNameController.text.trim(),
                    lastName: lastNameController.text.trim(),
                    studentId: studentIdController.text.trim(),
                    gradeLevel: gradeLevelController.text.trim(),
                    section: sectionController.text.trim(),
                    email: email,
                    password: password,
                  );
                }
                if (mounted) {
                  Navigator.pop(context);
                  _loadUsers();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(isEditing ? "User updated" : "User created successfully")),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Error: ${e.toString()}")),
                  );
                }
              }
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    final isDark = settings.isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFFAF3E0),
      appBar: AppBar(
        leadingWidth: 100,
        leading: TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            "Logout",
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          ),
        ),
        title: const Text("Admin Dashboard"),
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : const Color(0xFFC7B7A3),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showUserForm(),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _users.isEmpty
              ? const Center(child: Text("No users found"))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _users.length,
                  itemBuilder: (context, index) {
                    final user = _users[index];
                    return Card(
                      color: isDark ? const Color(0xFF2C2C2C) : Colors.white,
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blueAccent,
                          child: Text(user['firstName']?[0] ?? 'U', style: const TextStyle(color: Colors.white)),
                        ),
                        title: Text(
                          "${user['firstName']} ${user['lastName']}",
                          style: TextStyle(color: isDark ? Colors.white : Colors.black, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(user['email'] ?? '', style: TextStyle(color: isDark ? Colors.white70 : Colors.black54)),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => _editUser(user),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteUser(user['id']),
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UserSubjectsScreen(user: user),
                            ),
                          ).then((_) => _loadUsers());
                        },
                      ),
                    );
                  },
                ),
    );
  }
}

class UserSubjectsScreen extends StatefulWidget {
  final Map<String, dynamic> user;
  const UserSubjectsScreen({super.key, required this.user});

  @override
  State<UserSubjectsScreen> createState() => _UserSubjectsScreenState();
}

class _UserSubjectsScreenState extends State<UserSubjectsScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> _subjects = [];
  bool _isLoading = true;
  late String _currentFirstName;
  late String _currentLastName;

  @override
  void initState() {
    super.initState();
    _currentFirstName = widget.user['firstName'] ?? '';
    _currentLastName = widget.user['lastName'] ?? '';
    _loadSubjects();
  }

  Future<void> _loadSubjects() async {
    setState(() => _isLoading = true);
    final subjects = await _dbHelper.getSubjects(widget.user['id']);
    setState(() {
      _subjects = subjects;
      _isLoading = false;
    });
  }

  void _editUserName() {
    final firstNameController = TextEditingController(text: _currentFirstName);
    final lastNameController = TextEditingController(text: _currentLastName);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit User Name"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: firstNameController, decoration: const InputDecoration(labelText: "First Name")),
            TextField(controller: lastNameController, decoration: const InputDecoration(labelText: "Last Name")),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () async {
              await _dbHelper.updateUser(widget.user['id'], {
                'firstName': firstNameController.text.trim(),
                'lastName': lastNameController.text.trim(),
                'username': '${firstNameController.text.trim()} ${lastNameController.text.trim()}',
              });
              setState(() {
                _currentFirstName = firstNameController.text.trim();
                _currentLastName = lastNameController.text.trim();
              });
              if (mounted) Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  void _addSubject() {
    final titleController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add Subject"),
        content: TextField(controller: titleController, decoration: const InputDecoration(labelText: "Subject Title")),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () async {
              if (titleController.text.isNotEmpty) {
                await _dbHelper.addSubject({
                  'userId': widget.user['id'],
                  'title': titleController.text,
                  'overallGrade': 0.0,
                  'terminalAssessment': 0.0,
                  'assignments': 0.0,
                  'activity': 0.0,
                });
                _loadSubjects();
                if (mounted) Navigator.pop(context);
              }
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  void _removeSubject(int subjectId) async {
    bool? confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Remove Subject"),
        content: const Text("Are you sure you want to remove this subject?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Remove", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _dbHelper.deleteSubject(subjectId);
      _loadSubjects();
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    final isDark = settings.isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFFAF3E0),
      appBar: AppBar(
        title: Text("Manage: $_currentFirstName"),
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : const Color(0xFFC7B7A3),
        actions: [
          IconButton(icon: const Icon(Icons.edit_note), onPressed: _editUserName, tooltip: "Edit Name"),
          IconButton(icon: const Icon(Icons.library_add), onPressed: _addSubject, tooltip: "Add Subject"),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "User: $_currentFirstName $_currentLastName",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
                Expanded(
                  child: _subjects.isEmpty
                      ? const Center(child: Text("No subjects found for this user"))
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _subjects.length,
                          itemBuilder: (context, index) {
                            final subject = _subjects[index];
                            return Card(
                              color: isDark ? const Color(0xFF2C2C2C) : Colors.white,
                              margin: const EdgeInsets.only(bottom: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                              child: ListTile(
                                title: Text(
                                  subject['title'] ?? 'Untitled',
                                  style: TextStyle(color: isDark ? Colors.white : Colors.black, fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text("ID: ${subject['id']}"),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                                  onPressed: () => _removeSubject(subject['id']),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
