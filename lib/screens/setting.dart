import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:student_grade_tracker/l10n/app_localizations.dart';
import 'package:student_grade_tracker/widgets/bottom_nav.dart';
import 'package:student_grade_tracker/settings_provider.dart';
import '../database_helper.dart';
import '../google_classroom_service.dart';
import 'login.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final _dbHelper = DatabaseHelper();
  Map<String, dynamic>? _user;
  File? _image;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _user = _dbHelper.currentUser;
    if (_user != null && _user!['profileImage'] != null) {
      _image = File(_user!['profileImage']);
    }
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      if (_user != null) {
        await _dbHelper.updateProfileImage(_user!['id'], pickedFile.path);
        setState(() {
          _user = _dbHelper.currentUser;
        });
      }
    }
  }

  Future<void> _syncClassroom() async {
    if (_user == null) return;

    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final account = await GoogleClassroomService.signIn();
      
      if (mounted) Navigator.pop(context); // Close loading

      if (account != null) {
        // Show second loading for data sync
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => Center(
            child: Material(
              color: Colors.transparent,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(
                    "Syncing Classroom Data...",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14, // Fixed "so big" text
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
        
        await GoogleClassroomService.syncClassroomData(_user!['id']);
        
        if (mounted) {
          Navigator.pop(context); // Close sync loading
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Classroom Sync Successful!')),
          );
        }
      } else {
        // account is null means user cancelled or configuration error
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Sign-in cancelled or failed. Check logs.')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        // If loading dialog is still open, close it
        // Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sync failed: $e')),
        );
      }
    }
  }

  void _logout() async {
    await _dbHelper.clearUserSession();
    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  void _deleteAccount() async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteAccount, style: const TextStyle(color: Colors.red)),
        content: Text(l10n.deleteAccountConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.delete, style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true && _user != null) {
      await _dbHelper.deleteUser(_user!['id']);
      await _dbHelper.clearUserSession();
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
        );
      }
    }
  }

  void _showLanguageDialog() {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.selectLanguage),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLanguageOption('English', const Locale('en')),
            _buildLanguageOption('Filipino', const Locale('tl')),
            _buildLanguageOption('Japanese', const Locale('ja')),
            _buildLanguageOption('Korean', const Locale('ko')),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOption(String name, Locale locale) {
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    return ListTile(
      title: Text(name),
      trailing: settings.locale == locale ? const Icon(Icons.check, color: Color(0xFF3F78A8)) : null,
      onTap: () {
        settings.setLocale(locale);
        Navigator.pop(context);
      },
    );
  }

  void _showPrivacyDialog() {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.privacy),
        content: Text(l10n.privacyPolicy),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK')),
        ],
      ),
    );
  }

  void _showHelpDialog() {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.help),
        content: Text(l10n.helpContent),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK')),
        ],
      ),
    );
  }

  void _showAboutDialog() {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.about),
        content: Text(l10n.aboutContent),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    final isDark = settings.isDarkMode;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFFAF9F1),
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  // Profile Section
                  _buildProfileSection(isDark),
                  const SizedBox(height: 35),
                  // Settings Items
                  _buildSettingItem(
                    isDark: isDark,
                    icon: Icons.nightlight_round,
                    title: l10n.darkMode,
                    trailing: Transform.scale(
                      scale: 0.8,
                      child: Switch(
                        value: isDark,
                        onChanged: (value) {
                          settings.toggleDarkMode(value);
                        },
                        activeColor: Colors.white,
                        activeTrackColor: const Color(0xFF3F78A8),
                        inactiveThumbColor: Colors.white,
                        inactiveTrackColor: const Color(0xFFD7CCC8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildSettingItem(
                    isDark: isDark,
                    icon: Icons.translate,
                    title: l10n.language,
                    onTap: _showLanguageDialog,
                  ),
                  const SizedBox(height: 16),
                  _buildSettingItem(
                    isDark: isDark,
                    icon: Icons.lock_outline,
                    title: l10n.privacy,
                    onTap: _showPrivacyDialog,
                  ),
                  const SizedBox(height: 16),
                  _buildSettingItem(
                    isDark: isDark,
                    icon: Icons.school_outlined,
                    title: 'Sync Google Classroom',
                    onTap: _syncClassroom,
                  ),
                  const SizedBox(height: 16),
                  _buildSettingItem(
                    isDark: isDark,
                    icon: Icons.help_outline,
                    title: l10n.help,
                    onTap: _showHelpDialog,
                  ),
                  const SizedBox(height: 16),
                  _buildSettingItem(
                    isDark: isDark,
                    icon: Icons.info_outline,
                    title: l10n.about,
                    onTap: _showAboutDialog,
                  ),
                  const SizedBox(height: 16),
                  _buildSettingItem(
                    isDark: isDark,
                    icon: Icons.logout,
                    title: l10n.logout,
                    onTap: _logout,
                  ),
                  const SizedBox(height: 16),
                  _buildSettingItem(
                    isDark: isDark,
                    icon: Icons.delete_forever,
                    title: l10n.deleteAccount,
                    titleColor: Colors.redAccent,
                    iconColor: Colors.redAccent,
                    onTap: _deleteAccount,
                  ),
                  const SizedBox(height: 120), // Space for floating nav
                ],
              ),
            ),
          ),
          // Floating Bottom Nav
          Positioned(
            left: 20,
            right: 20,
            bottom: MediaQuery.of(context).padding.bottom + 10,
            child: const CustomBottomNav(activeTab: 'Profile'),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileSection(bool isDark) {
    String email = _user?['email'] ?? 'No email';
    String username = _user?['username'] ?? 'User Name';

    String formattedId = "N/A";
    if (_user != null) {
      final seed = _user!['id'] as int;
      final random = Random(seed);
      final randomNum = 10000 + random.nextInt(90000); // 5-digit random number
      formattedId = "${DateTime.now().year}-$randomNum";
    }

    return Column(
      children: [
        GestureDetector(
          onTap: _pickImage,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: isDark ? Colors.white24 : Colors.black12, width: 1),
                ),
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: const Color(0xFFBDC3C7),
                  backgroundImage: (_image != null && _image!.existsSync())
                      ? FileImage(_image!)
                      : null,
                  child: (_image == null || !_image!.existsSync())
                      ? const Icon(
                          Icons.person,
                          size: 90,
                          color: Colors.white,
                        )
                      : null,
                ),
              ),
              Positioned(
                bottom: 5,
                right: 5,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF424242) : Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                      )
                    ],
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    size: 18,
                    color: Color(0xFF3F78A8),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 15),
        Text(
          email,
          style: const TextStyle(
            color: Color(0xFF3F78A8),
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          'ID: $formattedId',
          style: TextStyle(
            color: isDark ? Colors.white70 : Colors.black54,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          username,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF333333),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingItem({
    required bool isDark,
    required IconData icon,
    required String title,
    Color? titleColor,
    Color? iconColor,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2C2C2C) : const Color(0xFFEFE6D8),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
        leading: Icon(icon, color: iconColor ?? (isDark ? Colors.white70 : const Color(0xFF333333)), size: 26),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: titleColor ?? (isDark ? Colors.white : const Color(0xFF333333)),
          ),
        ),
        trailing: trailing ??
            Icon(Icons.arrow_forward_ios, size: 18, color: isDark ? Colors.white38 : Colors.black45),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
    );
  }
}
