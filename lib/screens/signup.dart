import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_grade_tracker/l10n/app_localizations.dart';
import 'package:student_grade_tracker/settings_provider.dart';
import '../database_helper.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool _agreedToTerms = false;
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  final _dbHelper = DatabaseHelper();

  void _signup() async {
    final l10n = AppLocalizations.of(context)!;
    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.agreeToTermsError)),
      );
      return;
    }

    String fullName = _fullNameController.text.trim();
    String email = _emailController.text.trim();
    String password = _passwordController.text;
    String confirmPassword = _confirmPasswordController.text;

    if (fullName.isEmpty || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.pleaseFillAllFields)),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.passwordsDoNotMatch)),
      );
      return;
    }

    try {
      await _dbHelper.registerUser(fullName, email, password);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.registrationSuccessful)),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.registrationFailed)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    final isDark = settings.isDarkMode;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF6EFE1),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                const SizedBox(height: 40),
                // Logo and Title Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 90,
                      height: 100,
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                        border: Border.all(color: isDark ? Colors.white24 : const Color(0xFF333333), width: 3),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Clipboard top part
                          Positioned(
                            top: 0,
                            child: Container(
                              width: 50,
                              height: 15,
                              decoration: BoxDecoration(
                                color: isDark ? Colors.grey[700] : const Color(0xFFBDC3C7),
                                borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(8),
                                  bottomRight: Radius.circular(8),
                                ),
                                border: Border.all(color: isDark ? Colors.white24 : const Color(0xFF333333), width: 2),
                              ),
                            ),
                          ),
                          // GT Text and Circle
                          Container(
                            margin: const EdgeInsets.only(top: 15),
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: (isDark ? const Color(0xFF64B5F6) : const Color(0xFF8B5E3C)).withOpacity(0.3), width: 2),
                            ),
                            child: Text(
                              'GT',
                              style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                color: isDark ? const Color(0xFF64B5F6) : const Color(0xFF8B5E3C),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'GRADE',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.2,
                            color: isDark ? Colors.white : const Color(0xFF333333),
                          ),
                        ),
                        Text(
                          'TRACKER',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 1.2,
                            color: isDark ? Colors.white70 : const Color(0xFF333333),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 50),
                // Signup Clipboard Container
                Stack(
                  alignment: Alignment.topCenter,
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF2C2C2C) : const Color(0xFF4D4D4D),
                        borderRadius: BorderRadius.circular(35),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 15,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          children: [
                            const SizedBox(height: 60),
                            // Name field
                            _buildTextField(hintText: l10n.fullName, controller: _fullNameController, isDark: isDark),
                            const SizedBox(height: 20),
                            _buildTextField(hintText: l10n.email, controller: _emailController, isDark: isDark),
                            const SizedBox(height: 20),
                            _buildTextField(hintText: l10n.password, isPassword: true, controller: _passwordController, isDark: isDark),
                            const SizedBox(height: 20),
                            _buildTextField(hintText: l10n.confirmPassword, isPassword: true, controller: _confirmPasswordController, isDark: isDark),
                            const SizedBox(height: 20),
                            // Terms and Conditions
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      _agreedToTerms = !_agreedToTerms;
                                    });
                                  },
                                  child: Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: _agreedToTerms ? const Color(0xFF3F78A8) : (isDark ? Colors.grey[800] : const Color(0xFFD9D9D9)),
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                    child: _agreedToTerms
                                        ? const Icon(Icons.check, size: 18, color: Colors.white)
                                        : null,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    l10n.agreeToTerms,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 25),
                            // Sign Up Button
                            SizedBox(
                              width: double.infinity,
                              height: 60,
                              child: ElevatedButton(
                                onPressed: _signup,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF3F78A8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  elevation: 5,
                                ),
                                child: Text(
                                  l10n.signUp,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 30),
                            // Back to Login Link
                            _buildLinkButton(l10n.backToLogin, () {
                              Navigator.pop(context);
                            }),
                            const SizedBox(height: 40),
                          ],
                        ),
                      ),
                    ),
                    // Clipboard Clip
                    Positioned(
                      top: -15,
                      child: Container(
                        width: 120,
                        height: 45,
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF424242) : const Color(0xFFDCD2C1),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({required String hintText, bool isPassword = false, required TextEditingController controller, required bool isDark}) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF333333) : Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        style: TextStyle(fontSize: 18, color: isDark ? Colors.white : Colors.black87),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: isDark ? Colors.grey[500] : Colors.grey[400], fontSize: 17),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
        ),
      ),
    );
  }

  Widget _buildLinkButton(String text, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          decoration: TextDecoration.underline,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
