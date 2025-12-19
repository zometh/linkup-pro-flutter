import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:linkup_pro/core/theme/app_colors.dart';
import 'package:linkup_pro/core/widgets/custom_text.dart';
import 'package:linkup_pro/features/search/domain/entities/search_entities.dart';

class SearchSuggestionsOverlay extends StatelessWidget {
  final List<SearchSuggestion> suggestions;
  final bool isDark;
  final void Function(SearchSuggestion suggestion) onSuggestionTap;

  const SearchSuggestionsOverlay({
    super.key,
    required this.suggestions,
    required this.isDark,
    required this.onSuggestionTap,
  });

  Widget _buildSuggestionIcon(bool isDark, SearchSuggestion suggestion) {
    if (suggestion.photo != null) {
      return CircleAvatar(
        radius: 18,
        backgroundImage: CachedNetworkImageProvider(suggestion.photo!),
      );
    }

    IconData icon;
    switch (suggestion.type) {
      case 'people':
        icon = Icons.person;
        break;
      case 'company':
        icon = Icons.business;
        break;
      case 'job':
        icon = FontAwesomeIcons.briefcase;
        break;
      default:
        icon = Icons.search;
    }

    return CircleAvatar(
      radius: 18,
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      child: Icon(
        icon,
        size: 18,
        color: isDark ? Colors.white54 : AppColors.textTertiary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Material(
        color: isDark ? AppColors.darkSurface : Colors.white,
        elevation: 4,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
        child: ListView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          itemCount: suggestions.length,
          itemBuilder: (context, index) {
            final suggestion = suggestions[index];
            return ListTile(
              onTap: () => onSuggestionTap(suggestion),
              leading: _buildSuggestionIcon(isDark, suggestion),
              title: CustomText(
                text: suggestion.text,
                fontSize: 14,
                color: isDark ? Colors.white : AppColors.textPrimary,
              ),
              subtitle: suggestion.subtitle != null
                  ? CustomText(
                      text: suggestion.subtitle!,
                      fontSize: 12,
                      color: isDark ? Colors.white54 : AppColors.textSecondary,
                    )
                  : null,
              trailing: Icon(
                Icons.north_west,
                size: 16,
                color: isDark ? Colors.white38 : AppColors.textTertiary,
              ),
            );
          },
        ),
      ),
    );
  }
}

