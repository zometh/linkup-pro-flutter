import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:linkup_pro/core/services/localdb/localdb.dart';
import 'package:linkup_pro/main.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/assets_path.dart';
import '../../../posts_actions/presentation/pages/post_action_page.dart';

class HomeAppbar extends ConsumerStatefulWidget {
  const HomeAppbar({super.key});

  @override
  ConsumerState<HomeAppbar> createState() => _HomeAppbarState();
}

class _HomeAppbarState extends ConsumerState<HomeAppbar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;

    return AppBar(
      elevation: 0,
      scrolledUnderElevation: 0.5,
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      surfaceTintColor: Colors.transparent,
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.primaryDark],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: FadeTransition(
              opacity: _animation,
              child: Image.asset(
                AssetsPath.logo,
                height: 22,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 10),
      
        ],
      ),
      actions: [
        /*_buildActionButton(
          icon: FontAwesomeIcons.magnifyingGlass,
          onPressed: () {
            // TODO: Implement search functionality
          },
          isDark: isDark,
        ),*/
        _buildActionButton(
          icon: FontAwesomeIcons.plus,
          onPressed: () {
            MyNavigator(context).navigateTo(const PostActionPage());
          },
          isDark: isDark,
          isPrimary: true,
        ),
        _buildActionButton(
          icon: FontAwesomeIcons.bell,
          onPressed: () {
            // TODO: Implement messages functionality
          },
          isDark: isDark,
          showBadge: true,
        ),
        _buildActionButton(
          icon: FontAwesomeIcons.arrowLeftLong,
          onPressed: () async {
            final db = GetIt.I<LocalDBService>();
            await db.clearAllData();
            context.go("/splash");
            // TODO: Implement messages functionality
          },
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
          if (showBadge)
            Positioned(
              top: 6,
              right: 6,
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: AppColors.error,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isDark ? AppColors.darkSurface : Colors.white,
                    width: 1.5,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
