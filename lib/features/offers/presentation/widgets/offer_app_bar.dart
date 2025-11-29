/*import 'package:flutter/material.dart';
import 'package:linkup_pro/core/theme/app_colors.dart';
import 'package:linkup_pro/core/widgets/custom_text.dart';

class OfferAppBar extends StatelessWidget {
  const OfferAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == .dark;
    return SliverAppBar(
      expandedHeight: 200,
      floating: true,
      pinned: true,
      elevation: 0,
      backgroundColor: isDark ? AppColors.darkBackground : Colors.white,
      surfaceTintColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          padding: const EdgeInsets.fromLTRB(20, 56, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
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
                        text: '${_filteredOffers.length} opportunités',
                        fontSize: 14,
                        color: isDark
                            ? Colors.white54
                            : AppColors.textSecondary,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      _buildSavedButton(isDark),
                      const SizedBox(width: 8),
                      _buildNotificationButton(isDark),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildSearchField(isDark),
            ],
          ),
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(52),
        child: Container(
          height: 52,
          alignment: Alignment.centerLeft,
          child: _buildFilterTabs(isDark),
        ),
      ),
    );
  }
}*/
