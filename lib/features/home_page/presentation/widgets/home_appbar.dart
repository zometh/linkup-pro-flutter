import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:linkup_pro/core/services/localdb/localdb.dart';
import 'package:linkup_pro/features/home_page/presentation/widgets/animated_logo.dart';
import 'package:linkup_pro/main.dart';

import '../../../../core/routes/app_routes.dart';
import 'package:linkup_pro/features/splash/pages/splash_screen.dart';
import 'package:linkup_pro/core/network/websocket/config.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../posts_actions/presentation/pages/post_action_page.dart';

class HomeAppbar extends StatelessWidget {
  const HomeAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;

    return AppBar(
      elevation: 0,
      scrolledUnderElevation: 0.5,
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      surfaceTintColor: Colors.transparent,
      title: AnimatedLogo(),
      actions: [

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

          },
          isDark: isDark,
          showBadge: true,
        ),
        _buildActionButton(
          icon: FontAwesomeIcons.arrowLeftLong,
          onPressed: () => _logout(context),
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
  _logout(BuildContext context) async{
    final db = GetIt.I<LocalDBService>();
    SocketService? socketService;
    try{
      socketService = GetIt.I<SocketService>();
    }catch(_){
      socketService = null;
    }


    try{
      await db.clearAllData();
    }catch(_){

    }


    try{
      socketService?.dispose();
    }catch(_){

    }

    if(context.mounted){
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const SplashScreen()),
        (route) => false,
      );
    }
  }
}
