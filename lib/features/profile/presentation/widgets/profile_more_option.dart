
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';


class ProfileMoreOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isDarkMode;
  final bool isDestructive;
  final VoidCallback onTap;

  const ProfileMoreOption({super.key,
    required this.icon,
    required this.label,
    required this.isDarkMode,
    this.isDestructive = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive
            ? AppColors.error
            : (isDarkMode ? Colors.white : Colors.black),
      ),
      title: Text(
        label,
        style: TextStyle(
          color: isDestructive
              ? AppColors.error
              : (isDarkMode ? Colors.white : Colors.black),
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
    );
  }
}
