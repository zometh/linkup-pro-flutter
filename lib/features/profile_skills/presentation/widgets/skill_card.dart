import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:linkup_pro/core/theme/app_colors.dart';
import 'package:linkup_pro/core/widgets/custom_text.dart';
import 'package:linkup_pro/features/profile_skills/data/models/competence_model.dart';
import 'package:linkup_pro/features/profile_skills/presentation/widgets/level_chip.dart';

class SkillCard extends StatelessWidget {
  final CompetenceModel skill;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const SkillCard({
    super.key,
    required this.skill,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isDarkMode
                ? Colors.black.withOpacity(0.3)
                : Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        /*leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: AppGradients.primaryGradient,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.emoji_objects, color: Colors.white, size: 28),
        ),*/
        title: CustomText(
          text: skill.name,
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: isDarkMode ? Colors.white : Colors.black87,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (skill.category != null) ...[
              const SizedBox(height: 4),
              Text(
                skill.category!,
                style: TextStyle(
                  color: isDarkMode
                      ? Colors.grey.shade400
                      : Colors.grey.shade600,
                  fontSize: 14,
                ),
              ),
            ],
            if (skill.level != null) ...[
              const SizedBox(height: 8),
              LevelChip(level: skill.level!),
            ],
          ],
        ),
        trailing: PopupMenuButton(
          icon: Icon(
            Icons.more_vert,
            color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
          ),
          color: isDarkMode ? AppColors.darkSurface : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200,
            ),
          ),
          itemBuilder: (context) => [
            PopupMenuItem(
              child: Row(
                children: [
                  const Icon(Icons.edit, color: AppColors.primary, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'modify'.tr(),
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black87,
                    ),
                  ),
                ],
              ),
              onTap: () => Future.delayed(Duration.zero, onEdit),
            ),
            PopupMenuItem(
              child: Row(
                children: [
                  const Icon(Icons.delete, color: AppColors.error, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'delete'.tr(),
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black87,
                    ),
                  ),
                ],
              ),
              onTap: () => Future.delayed(Duration.zero, onDelete),
            ),
          ],
        ),
      ),
    );
  }
}
