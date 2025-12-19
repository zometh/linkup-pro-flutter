import 'package:flutter/material.dart';
import 'package:linkup_pro/core/theme/app_colors.dart';
import 'package:linkup_pro/core/widgets/custom_text.dart';

/// Search field widget for job offers
class OfferSearchField extends StatelessWidget {
  final TextEditingController controller;
  final String searchQuery;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;
  final VoidCallback? onFilterTap;
  final bool isDark;

  const OfferSearchField({
    super.key,
    required this.controller,
    required this.searchQuery,
    required this.onChanged,
    required this.onClear,
    this.onFilterTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 3,
      children: [
        Expanded(
          child: Container(
            height: 46,
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCard : const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              style: TextStyle(
                color: isDark ? Colors.white : AppColors.textPrimary,
                fontSize: 14,
              ),
              decoration: InputDecoration(
                hintText: 'Rechercher...',
                hintStyle: TextStyle(
                  color: isDark ? Colors.white38 : AppColors.textTertiary,
                  fontSize: 14,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: isDark ? Colors.white38 : AppColors.textTertiary,
                  size: 20,
                ),
                suffixIcon: searchQuery.isNotEmpty
                    ? GestureDetector(
                        onTap: onClear,
                        child: Icon(
                          Icons.close,
                          color: isDark
                              ? Colors.white38
                              : AppColors.textTertiary,
                          size: 18,
                        ),
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ),
        if (onFilterTap != null)
          GestureDetector(
            onTap: onFilterTap,
            child: Container(
              height: 46,
              width: 46,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.filter_list, color: Colors.white),
            ),
          ),
      ],
    );
  }
}

/// Filter tabs widget
class OfferFilterTabs extends StatelessWidget {
  final List<String> filters;
  final String selectedFilter;
  final ValueChanged<String> onFilterSelected;
  final bool isDark;

  const OfferFilterTabs({
    super.key,
    required this.filters,
    required this.selectedFilter,
    required this.onFilterSelected,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: filters.length,
      separatorBuilder: (_, __) => const SizedBox(width: 8),
      itemBuilder: (context, index) {
        final filter = filters[index];
        final isSelected = selectedFilter == filter;

        return GestureDetector(
          onTap: () => onFilterSelected(filter),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primary
                  : (isDark ? AppColors.darkCard : Colors.white),
              borderRadius: BorderRadius.circular(30),
              border: isSelected
                  ? null
                  : Border.all(
                      color: isDark ? Colors.white12 : const Color(0xFFE5E7EB),
                    ),
            ),
            child: CustomText(
              text: filter,
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected
                  ? Colors.white
                  : (isDark ? Colors.white70 : AppColors.textSecondary),
            ),
          ),
        );
      },
    );
  }
}
