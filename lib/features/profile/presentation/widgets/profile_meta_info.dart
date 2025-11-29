import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
class ProfileMetaInfo extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool isDarkMode;
  final bool isLink;

  const ProfileMetaInfo({super.key,
    required this.icon,
    required this.text,
    required this.isDarkMode,
    this.isLink = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 16,
          color: isDarkMode ? Colors.grey[500] : Colors.grey[600],
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 14,
            color: isLink
                ? AppColors.primary
                : (isDarkMode ? Colors.grey[500] : Colors.grey[600]),
          ),
        ),
      ],
    );
  }
}
