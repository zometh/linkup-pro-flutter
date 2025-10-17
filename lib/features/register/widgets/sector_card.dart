import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linkup_pro/core/theme/app_colors.dart';
import 'package:linkup_pro/core/widgets/custom_text.dart';

import '../data/entities/sector.dart';

class SectorCard extends StatelessWidget {
  final Sector sector;
  final bool selected;
  double? maxWidth;
  double? maxHeight;
  final VoidCallback? onTap;

  SectorCard({
    super.key,
    this.selected = false,
    required this.sector,
    this.maxWidth,
    this.maxHeight,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color color = getColor(sector.color);
    return GestureDetector(
      onTap: onTap,

      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: selected ? color : Colors.transparent,
            width: 2,
          ),
        ),
        elevation: selected ? 8 : 2,
        shadowColor: selected ? color.withAlpha(50) : Colors.black26,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          decoration: BoxDecoration(
            backgroundBlendMode: BlendMode.overlay,
            color: selected ? AppColors.primary : Colors.red,
            borderRadius: BorderRadius.circular(16),
            gradient: AppGradients.primaryGradient,
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(sector.icon, style: const TextStyle(fontSize: 36)),
              SizedBox(height: maxHeight != null ? maxHeight! * 0.02 : 8),
              CustomText(
                text: sector.name.tr(),
                //color: color,
                fontSize: maxWidth != null ? maxWidth! * 0.03 : 12,
                fontWeight: FontWeight.w600,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color getColor(String color) {
    return Color(int.parse("0XFF$color"));
  }
}
