import 'package:flutter/material.dart';
import 'package:student_grade_tracker/l10n/app_localizations.dart';
import 'package:student_grade_tracker/screens/add_subject.dart';
import 'package:student_grade_tracker/screens/home.dart';
import 'package:student_grade_tracker/screens/setting.dart';

class CustomBottomNav extends StatelessWidget {
  final String activeTab;
  final VoidCallback? onAddTap;

  const CustomBottomNav({
    super.key,
    required this.activeTab,
    this.onAddTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);

    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2C2C2C) : const Color(0xFFF1E4D3),
        borderRadius: BorderRadius.circular(35),
        border: Border.all(color: isDark ? Colors.white10 : Colors.black.withOpacity(0.1), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(
            context,
            Icons.home_rounded,
            l10n?.navHome ?? 'Home',
            activeTab == 'Home',
            isDark,
            () {
              if (activeTab != 'Home') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                );
              }
            },
          ),
          _buildNavItem(
            context,
            Icons.add_circle_outline_rounded,
            l10n?.navAdd ?? 'Add',
            activeTab == 'Add',
            isDark,
            () {
              if (onAddTap != null) {
                onAddTap!();
              } else if (activeTab != 'Add') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const AddSubjectScreen()),
                );
              }
            },
          ),
          _buildNavItem(
            context,
            Icons.person_pin_rounded,
            l10n?.navProfile ?? 'Profile',
            activeTab == 'Profile',
            isDark,
            () {
              if (activeTab != 'Profile') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingScreen()),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    IconData icon,
    String label,
    bool isActive,
    bool isDark,
    VoidCallback onTap,
  ) {
    final activeColor = isDark ? const Color(0xFF90CAF9) : const Color(0xFF5D4037);
    final inactiveColor = isDark ? Colors.white38 : Colors.black38;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(35),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isActive ? activeColor : inactiveColor,
              size: 28,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                color: isActive ? activeColor : inactiveColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
