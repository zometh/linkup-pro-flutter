import 'package:flutter/material.dart';
import 'package:linkup_pro/core/theme/app_colors.dart';
import 'package:linkup_pro/core/widgets/custom_text.dart';

/// Saved button for offer app bar
class SavedOffersButton extends StatelessWidget {
  final int savedCount;
  final bool showSavedOnly;
  final VoidCallback onTap;
  final bool isDark;

  const SavedOffersButton({
    super.key,
    required this.savedCount,
    required this.showSavedOnly,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: showSavedOnly
              ? AppColors.primary
              : (isDark ? AppColors.darkCard : AppColors.lightBackground),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              showSavedOnly ? Icons.bookmark : Icons.bookmark_outline,
              color: showSavedOnly
                  ? Colors.white
                  : (isDark ? Colors.white70 : AppColors.textSecondary),
              size: 18,
            ),
            if (savedCount > 0) ...[
              const SizedBox(width: 4),
              CustomText(
                text: '$savedCount',
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: showSavedOnly
                    ? Colors.white
                    : (isDark ? Colors.white70 : AppColors.textSecondary),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Member offers app bar header content
class MemberOffersHeader extends StatelessWidget {
  final int offersCount;
  final bool isDark;
  final Widget? trailing;

  const MemberOffersHeader({
    super.key,
    required this.offersCount,
    required this.isDark,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: 'Offres d\'emploi',
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : AppColors.textPrimary,
            ),
            const SizedBox(height: 4),
            CustomText(
              text: '$offersCount opportunité${offersCount > 1 ? 's' : ''}',
              fontSize: 14,
              color: isDark ? Colors.white54 : AppColors.textSecondary,
            ),
          ],
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}

/// My applications button
class MyApplicationsButton extends StatelessWidget {
  final int applicationsCount;
  final VoidCallback onTap;
  final bool isDark;

  const MyApplicationsButton({
    super.key,
    required this.applicationsCount,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.lightBackground,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.description_outlined,
              color: AppColors.primary,
              size: 18,
            ),
            const SizedBox(width: 6),
            CustomText(
              text: 'Mes candidatures',
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.primary,
            ),
            if (applicationsCount > 0) ...[
              const SizedBox(width: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: CustomText(
                  text: '$applicationsCount',
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
