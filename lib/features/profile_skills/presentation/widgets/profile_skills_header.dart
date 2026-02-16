import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:linkup_pro/core/theme/app_colors.dart';
import 'package:go_router/go_router.dart';

class ProfileSkillsHeader extends StatelessWidget {
  const ProfileSkillsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: AppGradients.primaryGradient,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => GoRouter.of(context).pop(),
          ),
          const SizedBox(width: 8),
          Text(
            'my_skills'.tr(),
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
