import 'package:flutter/material.dart';
import 'package:linkup_pro/core/theme/app_colors.dart';
import 'package:linkup_pro/features/search/domain/entities/search_entities.dart';
import 'package:linkup_pro/features/search/presentation/providers/search_provider.dart';

class SearchTypeFilters extends StatelessWidget {
  final SearchState searchState;
  final bool isDark;
  final void Function(SearchType type) onTypeSelected;

  const SearchTypeFilters({
    super.key,
    required this.searchState,
    required this.isDark,
    required this.onTypeSelected,
  });

  int _getCountForType(SearchType type, SearchCategories? categories) {
    if (categories == null) return 0;
    switch (type) {
      case SearchType.all:
        return categories.total;
      case SearchType.people:
        return categories.people;
      case SearchType.companies:
        return categories.companies;
      case SearchType.posts:
        return categories.posts;
      case SearchType.jobs:
        return categories.jobs;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: SearchType.values.map((type) {
          final isSelected = searchState.type == type;
          final count = _getCountForType(type, searchState.categories);

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              selected: isSelected,
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(type.label),
                  if (count > 0) ...[
                    const SizedBox(width: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.white.withOpacity(0.2)
                            : AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        count.toString(),
                        style: TextStyle(
                          fontSize: 11,
                          color: isSelected ? Colors.white : AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              selectedColor: AppColors.primary,
              backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
              labelStyle: TextStyle(
                color: isSelected
                    ? Colors.white
                    : (isDark ? Colors.white70 : AppColors.textPrimary),
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
              onSelected: (_) => onTypeSelected(type),
            ),
          );
        }).toList(),
      ),
    );
  }
}

