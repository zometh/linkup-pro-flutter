import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:linkup_pro/features/home_page/presentation/widgets/animated_logo.dart';
import 'package:linkup_pro/main.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../notifications/presentation/providers/notification_provider.dart';

class HomeAppbar extends ConsumerStatefulWidget {
  const HomeAppbar({super.key});

  @override
  ConsumerState<HomeAppbar> createState() => _HomeAppbarState();
}

class _HomeAppbarState extends ConsumerState<HomeAppbar> {
  @override
  void initState() {
    super.initState();
    // Charger les notifications au démarrage
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(notificationsProvider.notifier).loadNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final badgeCount = ref.watch(notificationsProvider).unreadCount;

    return AppBar(
      elevation: 0,
      scrolledUnderElevation: 0.5,
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      surfaceTintColor: Colors.transparent,
      title: AnimatedLogo(),
      actions: [
        _buildActionButton(
          icon: FontAwesomeIcons.plus,
          onPressed: () => context.push('/post/new'),
          isDark: isDark,
          isPrimary: true,
        ),
        _buildActionButton(
          icon: FontAwesomeIcons.bell,
          onPressed: () => context.push('/notifications'),
          isDark: isDark,
          showBadge: true,
          badgeCount: badgeCount,
        ),
        _buildActionButton(
          icon: FontAwesomeIcons.gear,
          onPressed: () => context.push('/settings'),
          isDark: isDark,
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback onPressed,
    required bool isDark,
    bool isPrimary = false,
    bool showBadge = false,
    int badgeCount = 0,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Stack(
        children: [
          Container(
            decoration: isPrimary
                ? BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, AppColors.primaryDark],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  )
                : BoxDecoration(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.08)
                        : Colors.grey.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onPressed,
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Icon(
                    icon,
                    size: 18,
                    color: isPrimary
                        ? Colors.white
                        : isDark
                        ? Colors.white70
                        : AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          ),
          if (showBadge && badgeCount > 0)
            Positioned(
              top: 2,
              right: 2,
              child: Container(
                padding: const EdgeInsets.all(4),
                constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                decoration: BoxDecoration(
                  color: AppColors.error,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isDark ? AppColors.darkSurface : Colors.white,
                    width: 1.5,
                  ),
                ),
                child: Text(
                  badgeCount > 99 ? '99+' : '$badgeCount',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    height: 1,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
