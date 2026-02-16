import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linkup_pro/core/theme/app_colors.dart';
import 'package:linkup_pro/core/widgets/custom_text.dart';

class SearchEmptyState extends StatelessWidget {
  final bool isDark;

  const SearchEmptyState({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search,
            size: 64,
            color: isDark ? Colors.white24 : AppColors.textTertiary,
          ),
          const SizedBox(height: 16),
          CustomText(
            text: 'search_page_description'
            .tr(),
            fontSize: 14,
            color: isDark ? Colors.white54 : AppColors.textSecondary,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class SearchNoResultsState extends StatelessWidget {
  final bool isDark;
  final String query;

  const SearchNoResultsState({
      super.key,
    required this.isDark,
    required this.query,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: isDark ? Colors.white24 : AppColors.textTertiary,
            ),
            const SizedBox(height: 16),
            CustomText(
              text: 'Aucun résultat pour "$query"',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white70 : AppColors.textPrimary,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            CustomText(
              text: 'Essayez avec d\'autres mots-clés',
              fontSize: 14,
              color: isDark ? Colors.white38 : AppColors.textSecondary,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class SearchErrorState extends StatelessWidget {
  final bool isDark;
  final String error;
  final VoidCallback onRetry;

  const SearchErrorState({
    super.key,
    required this.isDark,
    required this.error,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red.shade300,
          ),
          const SizedBox(height: 16),
          CustomText(
            text: error,
            fontSize: 14,
            color: isDark ? Colors.white54 : AppColors.textSecondary,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onRetry,
            child: const Text('Réessayer'),
          ),
        ],
      ),
    );
  }
}

