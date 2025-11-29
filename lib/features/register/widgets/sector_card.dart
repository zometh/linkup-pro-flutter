import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linkup_pro/core/theme/app_colors.dart';
import 'package:linkup_pro/core/widgets/custom_text.dart';
import 'package:linkup_pro/main.dart';

import '../data/entities/sector.dart';

class SectorCard extends StatelessWidget {
  final Sector sector;
  final bool selected;
  final double? maxWidth;
  final double? maxHeight;
  final VoidCallback? onTap;

  const SectorCard({
    super.key,
    this.selected = false,
    required this.sector,
    this.maxWidth,
    this.maxHeight,
    this.onTap,
  });

  Color _parseColor(String hex) {
    try {
      return Color(int.parse("0xFF$hex"));
    } catch (_) {
      return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final color = _parseColor(sector.color);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withValues(alpha: 0.6), width: 1.3),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.08),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Text(sector.icon, style: const TextStyle(fontSize: 28)),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: CustomText(
                  text: sector.name.tr(),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  textAlign: TextAlign.center,
                  color: isDark ? Colors.white : AppColors.textPrimary,
                  maxLines: 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
