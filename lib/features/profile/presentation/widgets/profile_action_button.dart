import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class ProfileActionButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isDarkMode;
  final bool isPrimary;
  final bool isOutlined;

  const ProfileActionButton({super.key,
    required this.label,
    required this.onPressed,
    required this.isDarkMode,
    this.isPrimary = false,
    this.isOutlined = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isPrimary
                ? (isDarkMode ? Colors.white : Colors.black)
                : isOutlined
                ? Colors.transparent
                : (isDarkMode ? AppColors.darkCard : Colors.white),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isOutlined || !isPrimary
                  ? (isDarkMode
                  ? Colors.white.withValues(alpha: 0.3)
                  : Colors.black.withValues(alpha: 0.2))
                  : Colors.transparent,
              width: 1,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: isPrimary
                  ? (isDarkMode ? Colors.black : Colors.white)
                  : (isDarkMode ? Colors.white : Colors.black),
            ),
          ),
        ),
      ),
    );
  }
}
