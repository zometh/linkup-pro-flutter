import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:linkup_pro/features/bottom_nav_bar/providers/bottom_navbar.dart';
import 'package:linkup_pro/main.dart';

class BottomNavbar extends ConsumerWidget {

  const BottomNavbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int _currentIndex = ref.watch(bottomNavbarProvider);
    final List<_NavItem> _items = const [
      _NavItem(icon: FontAwesomeIcons.house, label: 'Home'),
      _NavItem(icon: FontAwesomeIcons.magnifyingGlass, label: 'Search'),
      _NavItem(icon: FontAwesomeIcons.message, label: 'Messages'),
      _NavItem(icon: FontAwesomeIcons.bell, label: 'Notifications'),
      _NavItem(icon: FontAwesomeIcons.user, label: "Profile"),
    ];

    final double width = context.screenWidth;
    final double height = context.screenHeight;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    // Enhanced glassmorphic colors
    final Color bgColor = isDark
        ? Colors.black.withAlpha((0.6 * 255).round())
        : Colors.white.withAlpha((0.8 * 255).round());
    final Color borderColor = isDark
        ? Colors.white.withAlpha((0.15 * 255).round())
        : Colors.black.withAlpha((0.08 * 255).round());
    final Color activeColor = Theme.of(context).colorScheme.primary;
    final Color inactiveColor = isDark ? Colors.grey.shade500 : Colors.grey.shade600;

    return Container(

      margin: EdgeInsets.only(
        left: width * 0.03,
        right: width * 0.03,
        bottom: height * 0.02,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            height: 70,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: borderColor,
                width: 0.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? Colors.black.withAlpha((0.5 * 255).round())
                      : Colors.black.withAlpha((0.1 * 255).round()),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                  spreadRadius: -4,
                ),
                BoxShadow(
                  color: isDark
                      ? Colors.black.withAlpha((0.3 * 255).round())
                      : Colors.black.withAlpha((0.05 * 255).round()),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(_items.length, (index) {
                final bool active = index == _currentIndex;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => ref.read(bottomNavbarProvider.notifier).setIndex(index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeInOutCubic,
                      decoration: BoxDecoration(
                        color: active
                            ? activeColor.withAlpha((0.18 * 255).round())
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeInOutCubic,
                            transform: Matrix4.identity()
                              ..scale(active ? 1.15 : 1.0),
                            child: Icon(
                              _items[index].icon,
                              size: 22,
                              color: active ? activeColor : inactiveColor,
                            ),
                          ),
                          const SizedBox(height: 6),
                           _currentIndex == index ? AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeInOutCubic,
                            style: TextStyle(
                              fontSize: active ? 8 : 7,
                              fontWeight: active ? FontWeight.w600 : FontWeight.w500,
                              color: active ? activeColor : inactiveColor,
                              letterSpacing: 0.2,
                            ),
                            child: Text(
                              _items[index].label,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ) : const SizedBox.shrink(),
                        ],
                      ),
                    ).animate(
                      target: active ? 1 : 0,
                    ).shimmer(
                      duration: 300.ms,
                      color: activeColor.withAlpha((0.3 * 255).round()),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );

  }

}

class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem({required this.icon, required this.label});
}

