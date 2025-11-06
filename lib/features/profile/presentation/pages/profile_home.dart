import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linkup_pro/core/theme/app_colors.dart';
import 'package:linkup_pro/features/profile/presentation/widgets/profile_header.dart';

class ProfileHome extends StatelessWidget {
  final bool isOwnProfile;
  final String? userId;
  const ProfileHome({super.key, required this.isOwnProfile, this.userId});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return LayoutBuilder(
      builder: (_, cx) {
        return Scaffold(
          backgroundColor: isDarkMode ? AppColors.darkBackground : AppColors.lightBackground,
          body: SingleChildScrollView(
            child: Column(
              children: [
                // Profile Header
                 ProfileHeader(
                  cx: cx,
                  isOwnProfile: true, // Change to false to see other profile view
                ),

                // Tabs ou contenu supplémentaire
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // Tabs pour Posts, About, Media, etc.
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: isDarkMode ? AppColors.darkCard : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            _TabItem(
                              label: 'Posts',
                              isSelected: true,
                              isDarkMode: isDarkMode,
                            ),
                            _TabItem(
                              label: 'About',
                              isSelected: false,
                              isDarkMode: isDarkMode,
                            ),
                            _TabItem(
                              label: 'Media',
                              isSelected: false,
                              isDarkMode: isDarkMode,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Placeholder pour le contenu
                      Container(
                        padding: const EdgeInsets.all(40),
                        decoration: BoxDecoration(
                          color: isDarkMode ? AppColors.darkCard : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: Column(
                            children: [
                              Icon(
                                Icons.article_outlined,
                                size: 60,
                                color: isDarkMode
                                    ? Colors.white.withValues(alpha: 0.3)
                                    : AppColors.textTertiary,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No posts yet',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: isDarkMode ? Colors.white60 : AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Start sharing your thoughts',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: isDarkMode ? Colors.white38 : AppColors.textTertiary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}

class _TabItem extends StatelessWidget {
  final String label;
  final bool isSelected;
  final bool isDarkMode;

  const _TabItem({
    required this.label,
    required this.isSelected,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          gradient: isSelected ? AppGradients.primaryGradient : null,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isSelected
                ? Colors.white
                : isDarkMode
                    ? Colors.white60
                    : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
