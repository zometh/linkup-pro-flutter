import 'package:flutter/material.dart';
import 'package:linkup_pro/core/theme/app_colors.dart';
import 'package:linkup_pro/core/widgets/custom_text.dart';

/// Section header with optional badge
class OfferSectionHeader extends StatelessWidget {
  final String title;
  final bool isDark;
  final bool showBadge;
  final String? badgeText;
  final IconData? badgeIcon;

  const OfferSectionHeader({
    super.key,
    required this.title,
    required this.isDark,
    this.showBadge = false,
    this.badgeText,
    this.badgeIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Row(
        children: [
          CustomText(
            text: title,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : AppColors.textPrimary,
          ),
          if (showBadge) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (badgeIcon != null)
                    Icon(badgeIcon, size: 12, color: AppColors.primary),
                  if (badgeIcon != null && badgeText != null)
                    const SizedBox(width: 4),
                  if (badgeText != null)
                    CustomText(
                      text: badgeText!,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primary,
                    ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}


class OffersEmptyState extends StatelessWidget {
  final bool isDark;
  final VoidCallback? onReset;
  final String title;
  final String subtitle;

  const OffersEmptyState({
    super.key,
    required this.isDark,
    this.onReset,
    this.title = 'Aucune offre trouvée',
    this.subtitle = 'Modifiez vos filtres ou votre recherche',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.work_off_outlined,
              size: 48,
              color: isDark ? Colors.white24 : AppColors.textTertiary,
            ),
            const SizedBox(height: 12),
            CustomText(
              text: title,
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white70 : AppColors.textPrimary,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            CustomText(
              text: subtitle,
              fontSize: 12,
              color: isDark ? Colors.white38 : AppColors.textSecondary,
              textAlign: TextAlign.center,
            ),
            if (onReset != null) ...[
              const SizedBox(height: 12),
              TextButton(
                onPressed: onReset,
                child: const Text('Réinitialiser'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}


class OffersLoadingIndicator extends StatelessWidget {
  const OffersLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: CircularProgressIndicator(),
      ),
    );
  }
}

/// Error widget for offers
class OffersErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  final bool isDark;

  const OffersErrorWidget({
    super.key,
    required this.message,
    this.onRetry,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 56, color: Colors.red.shade300),
            const SizedBox(height: 16),
            CustomText(
              text: 'Une erreur est survenue',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white70 : AppColors.textPrimary,
            ),
            const SizedBox(height: 8),
            CustomText(
              text: message,
              fontSize: 13,
              color: isDark ? Colors.white38 : AppColors.textSecondary,
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: onRetry,
                child: const Text('Réessayer'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
