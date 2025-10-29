import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:linkup_pro/core/theme/app_colors.dart';
import 'package:linkup_pro/core/widgets/custom_text.dart';

class TextfieldLabel extends StatelessWidget {
  final String title;
  final IconData icon;
  final BoxConstraints constraints;

  const TextfieldLabel({
    super.key,
    required this.title,
    required this.icon,
    required this.constraints,
  });

  @override
  Widget build(BuildContext context) {
    // If constraints are unbounded, fall back to screen width
    final double maxWidth = constraints.maxWidth.isFinite
        ? constraints.maxWidth
        : MediaQuery.of(context).size.width;

    // Scale values and clamp to reasonable min/max so the widget remains usable on all screens
    final double iconSize = ((maxWidth * 0.06).clamp(16, 28)).toDouble();
    final double padding = ((maxWidth * 0.02).clamp(6, 12)).toDouble();
    final double gap = ((maxWidth * 0.03).clamp(6, 20)).toDouble();
    final double fontSize = ((maxWidth * 0.04).clamp(12, 20)).toDouble();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(padding),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: iconSize, color: AppColors.primary),
        ),
        SizedBox(width: gap),
        // Allow the text to take remaining space and wrap if needed
        Flexible(
          child: CustomText(
            text: title.tr(),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            fontSize: fontSize,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ).animate().fadeIn(duration: 500.ms, delay: 700.ms);
  }
}
