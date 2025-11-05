import 'package:flutter/material.dart';
import 'package:linkup_pro/core/theme/app_colors.dart';

class ToolbarButton extends StatelessWidget {
  final IconData icon;
   final    String tooltip;
  final VoidCallback onTap;
  const ToolbarButton({super.key, required this.icon, required this.tooltip, required this.onTap});

  @override
  Widget build(BuildContext context) {


      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Icon(
              icon,
              size: 24,
              color: AppColors.primary,
            ),
          ),
        ),
      );
    }

  }

