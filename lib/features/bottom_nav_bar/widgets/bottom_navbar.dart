import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:linkup_pro/core/theme/app_colors.dart';
import 'package:linkup_pro/core/widgets/custom_text.dart';
import 'package:linkup_pro/features/bottom_nav_bar/providers/bottom_navbar.dart';

class BottomNavbar extends ConsumerWidget {
  const BottomNavbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int currentIndex = ref.watch(bottomNavbarProvider);
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDark
              ? [AppColors.darkSurface, AppColors.darkBackground]
              : [Colors.white, Colors.grey.shade50],
        ),
        border: Border(
          top: BorderSide(
            color: isDark
                ? Colors.white.withValues(alpha: 0.08)
                : Colors.black.withValues(alpha: 0.06),
            width: 0.5,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.4)
                : AppColors.primary.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
            spreadRadius: -2,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(5, (index) {
            final items = [
              _NavItemData(
                icon: FontAwesomeIcons.house,
                activeIcon: FontAwesomeIcons.house,
                label: 'home'.tr(),
              ),
              _NavItemData(
                icon: FontAwesomeIcons.magnifyingGlass,
                activeIcon: FontAwesomeIcons.magnifyingGlass,
                label: 'search'.tr(),
              ),
              _NavItemData(
                icon: FontAwesomeIcons.message,
                activeIcon: FontAwesomeIcons.solidMessage,
                label: 'messages'.tr(),
                badgeCount: 2,
              ),
              _NavItemData(
                icon: FontAwesomeIcons.briefcase,
                activeIcon: FontAwesomeIcons.briefcase,
                label: 'job'.tr(),
                badgeCount: 2,
              ),
              _NavItemData(
                icon: FontAwesomeIcons.user,
                activeIcon: FontAwesomeIcons.solidUser,
                label: 'profile'.tr(),
              ),
            ];

            final item = items[index];
            final isActive = currentIndex == index;

            return Expanded(
              child: GestureDetector(
                onTap: () =>
                    ref.read(bottomNavbarProvider.notifier).setIndex(index),
                behavior: HitTestBehavior.opaque,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOutCubic,
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeOutCubic,
                            padding: EdgeInsets.all(isActive ? 8 : 6),
                            decoration: BoxDecoration(
                              color: isActive
                                  ? (isDark
                                        ? AppColors.primary.withValues(
                                            alpha: 0.15,
                                          )
                                        : AppColors.primary.withValues(
                                            alpha: 0.1,
                                          ))
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              isActive ? item.activeIcon : item.icon,
                              size: isActive ? 22 : 20,
                              color: isActive
                                  ? AppColors.primary
                                  : (isDark
                                        ? Colors.grey.shade400
                                        : Colors.grey.shade600),
                            ),
                          ),
                          if (item.showBadge)
                            Positioned(
                              top: 0,
                              right: 0,
                              child: Container(
                                padding: const .fromLTRB(
                                  3,
                                  2,
                                  3,
                                    3
                                ),
                                constraints: const BoxConstraints(
                                  /* minWidth: 16,
                                  minHeight: 16,*/
                                  maxHeight: 17,
                                  maxWidth: 17,
                                ),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFFFF6B6B),
                                      AppColors.error,
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(45),
                                  border: Border.all(
                                    color: isDark
                                        ? AppColors.darkSurface
                                        : Colors.white,
                                    width: 1.5,
                                  ),
                                 /* boxShadow: [
                                    BoxShadow(
                                      color: AppColors.error.withValues(
                                        alpha: 0.4,
                                      ),
                                      blurRadius: 4,
                                      spreadRadius: 0,
                                    ),
                                  ],*/
                                ),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: CustomText(
                                    text: item.badgeCount! > 99
                                        ? '99+'
                                        : item.badgeCount.toString(),
                                    fontSize: 8,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeOutCubic,
                        height: 3,
                        width: isActive ? 20 : 0,
                        margin: const EdgeInsets.only(bottom: 6),
                        decoration: BoxDecoration(
                          gradient: isActive
                              ? const LinearGradient(
                                  colors: [
                                    AppColors.primaryLight,
                                    AppColors.primary,
                                  ],
                                )
                              : null,
                          borderRadius: BorderRadius.circular(2),
                          boxShadow: isActive
                              ? [
                                  BoxShadow(
                                    color: AppColors.primary.withValues(
                                      alpha: 0.5,
                                    ),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ]
                              : null,
                        ),
                      ),

                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class _NavItemData {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final int? badgeCount;

  const _NavItemData({
    required this.icon,
    required this.activeIcon,
    required this.label,
    this.badgeCount,
  });

  bool get showBadge => badgeCount != null && badgeCount! > 0;
}
