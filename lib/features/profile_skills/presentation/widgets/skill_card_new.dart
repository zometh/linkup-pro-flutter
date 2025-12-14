import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:linkup_pro/core/theme/app_colors.dart';
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
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onEdit,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              skill.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          if (skill.level != null) ...[
                            LevelChip(level: skill.level!),
                          ],
                        ],
                      ),
                      if (skill.category != null) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                skill.category!,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade700,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                PopupMenuButton(
                  icon: Icon(
                    Icons.more_horiz,
                    color: Colors.grey.shade600,
                    size: 20,
                  ),
                  padding: EdgeInsets.zero,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(color: Colors.grey.shade200),
                  ),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.edit_outlined,
                            color: Colors.grey.shade700,
                            size: 18,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'modify'.tr(),
                            style: TextStyle(
                              color: Colors.grey.shade800,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      onTap: () => Future.delayed(Duration.zero, onEdit),
                    ),
                    PopupMenuItem(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.delete_outline,
                            color: AppColors.error,
                            size: 18,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'delete'.tr(),
                            style: const TextStyle(
                              color: AppColors.error,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      onTap: () => Future.delayed(Duration.zero, onDelete),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
