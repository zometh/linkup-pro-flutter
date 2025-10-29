import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:linkup_pro/features/bottom_nav_bar/providers/bottom_navbar.dart';

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

    final Color activeColor = Theme.of(context).colorScheme.primary;
    final Color inactiveColor = Colors.grey.shade400;
    final currentIndex = ref.watch(bottomNavbarProvider);
    return BottomNavigationBar(
      useLegacyColorScheme: true,
      currentIndex: currentIndex,
      onTap: (index) => ref.read(bottomNavbarProvider.notifier).setIndex(index),
      type: BottomNavigationBarType.shifting,
      items: _items.map((item) {

          final bool active = _items.indexOf(item) == _currentIndex;
          return BottomNavigationBarItem(

            tooltip: _items.indexOf(item).toString(),
            icon: Icon(
              item.icon,
              size: active ? 24 : 20,
              color: active ? activeColor : inactiveColor,
            ).animate(
              onPlay: (controller) => controller.forward(),
            ).scale(
              begin: active ? Offset(0.8, 0.8) : Offset(1.0, 1.0),
              end: active ? Offset(1.2, 1.2) : Offset(1.0, 1.0),
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutBack,
            ),
            label: item.label,
          );
        }).toList(),
      );
  }

}

class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem({required this.icon, required this.label});
}
