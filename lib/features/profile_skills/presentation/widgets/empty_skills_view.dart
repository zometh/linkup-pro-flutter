import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:linkup_pro/core/theme/app_colors.dart';

class EmptySkillsView extends StatelessWidget {
  final VoidCallback? onAddSkill;
  final bool isOwnProfile;

  const EmptySkillsView({super.key, this.onAddSkill, this.isOwnProfile = false});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.school_outlined, size: 80, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'no_skills_added'.tr(),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          if(isOwnProfile) Text(
            'start_adding_skills'.tr(),
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600),
          ),
          if (onAddSkill != null && isOwnProfile) ...[
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onAddSkill,
              icon: const Icon(Icons.add, color: Colors.white),
              label: Text('add_skill'.tr()),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
