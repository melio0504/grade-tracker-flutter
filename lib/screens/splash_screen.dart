import 'dart:async';
import 'package:flutter/material.dart';
import 'package:student_grade_tracker/screens/home.dart';
import 'package:student_grade_tracker/screens/login.dart';
import 'package:student_grade_tracker/database_helper.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _logoAnimation;
  late Animation<double> _text1Animation;
  late Animation<double> _text2Animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _logoAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
    );

    _text1Animation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.2, 0.8, curve: Curves.elasticOut),
    );

    _text2Animation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.4, 1.0, curve: Curves.elasticOut),
    );

    _controller.forward();

    _navigateToNext();
  }

  void _navigateToNext() async {
    final dbHelper = DatabaseHelper();
    bool isLoggedIn = await dbHelper.tryAutoLogin();

    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => isLoggedIn ? const HomeScreen() : const LoginScreen(),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF6EFE1),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ScaleTransition(
              scale: _logoAnimation,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                  border: Border.all(color: isDark ? Colors.white24 : const Color(0xFF333333), width: 4),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      top: 8,
                      child: Container(
                        width: 50,
                        height: 12,
                        decoration: BoxDecoration(
                          color: isDark ? Colors.grey[800] : Colors.grey[300],
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                    Text(
                      'GT',
                      style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        color: isDark ? const Color(0xFF64B5F6) : const Color(0xFF8B5E3C),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 25),
            ScaleTransition(
              scale: _text1Animation,
              child: Text(
                'GRADE',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 2,
                  color: isDark ? Colors.white : const Color(0xFF333333),
                ),
              ),
            ),
            ScaleTransition(
              scale: _text2Animation,
              child: Text(
                'TRACKER',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 2,
                  color: isDark ? Colors.white70 : const Color(0xFF333333),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
