import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linkup_pro/core/theme/app_colors.dart';
import 'package:linkup_pro/features/profile_skills/presentation/providers/profile_skills_provider.dart';

class DeleteSkillDialog extends ConsumerWidget {
  final String skillId;

  const DeleteSkillDialog({super.key, required this.skillId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      backgroundColor: AppColors.darkCard,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        children: [
          const Icon(Icons.warning_amber_rounded, color: AppColors.error),
          const SizedBox(width: 8),
          Text(
            'confirmation'.tr(),
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
      content: Text(
        'delete_skill_confirmation'.tr(),
        style: const TextStyle(color: Colors.white70),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'cancel'.tr(),
            style: const TextStyle(color: Colors.white70),
          ),
        ),
        ElevatedButton(
          onPressed: () => _handleDelete(context, ref),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.error,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            'delete'.tr(),
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

  Future<void> _handleDelete(BuildContext context, WidgetRef ref) async {
    final success = await ref
        .read(profileSkillsProvider.notifier)
        .deleteSkill(skillId);

    if (context.mounted) {
      Navigator.pop(context);
    }

    if (success && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('skill_deleted_successfully'.tr()),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }
}
