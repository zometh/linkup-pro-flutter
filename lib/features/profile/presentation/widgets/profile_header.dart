import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:linkup_pro/features/profile/presentation/widgets/edit_profile_button.dart';
import 'package:linkup_pro/features/profile/presentation/widgets/follow_button.dart';
import 'package:linkup_pro/features/profile/presentation/widgets/profile_action_button.dart';

import '../../../../core/entities/company.dart';
import '../../../../core/entities/member.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/services/profile_utils.dart';

class ProfileHeader extends StatelessWidget {
  final BoxConstraints cx;
  final bool isOwnProfile;
  final bool isMember;
  final Member? memberInfos;
  final Company? companyInfos;

  const ProfileHeader({
    super.key,
    required this.isOwnProfile,
    required this.cx,
    required this.isMember,
    this.memberInfos,
    this.companyInfos,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final statusBarHeight = MediaQuery.of(context).padding.top;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Background with gradient and pattern overlay
        Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primary,
                AppColors.primaryDark,
                AppColors.primaryDark.withValues(alpha: 0.9),
              ],
              stops: const [0.0, 0.6, 1.0],
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                top: -30,
                right: -30,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.08),
                  ),
                ),
              ),
              Positioned(
                bottom: 20,
                left: -40,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.05),
                  ),
                ),
              ),

              Positioned.fill(
                child: CustomPaint(painter: _DotPatternPainter()),
              ),
            ],
          ),
        ),

        if (!isOwnProfile)
          Positioned(
            top: statusBarHeight + 8,
            left: 12,
            child: _buildGlassButton(
              icon: Icons.arrow_back_ios_new_rounded,
              onTap: () => Navigator.pop(context),
              size: 40,
            ),
          ),

        if (isOwnProfile)
          Positioned(
            top: statusBarHeight + 8,
            right: 12,
            child: _buildGlassButton(
              icon: Icons.settings_outlined,
              onTap: () {},
              size: 40,
            ),
          ),

        Positioned(
          bottom: -45,
          left: 20,
          child: _buildProfileAvatar(isDarkMode),
        ),

        Positioned(
          bottom: 12,
          right: 16,
          child: _buildActionButtons(context, isDarkMode),
        ),
      ],
    );
  }

  Widget _buildGlassButton({
    required IconData icon,
    required VoidCallback onTap,
    double size = 44,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Material(
          color: Colors.white.withValues(alpha: 0.15),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: Icon(icon, color: Colors.white, size: 20),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileAvatar(bool isDarkMode) {
    final hasImage =
        (isMember && memberInfos?.photoUrl != null) ||
        (companyInfos != null && companyInfos!.logo.isNotEmpty);

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isDarkMode ? AppColors.darkBackground : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: !hasImage
                  ? LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.primaryLight.withValues(alpha: 0.3),
                        AppColors.primary.withValues(alpha: 0.1),
                      ],
                    )
                  : null,
            ),
            child: CircleAvatar(
              radius: 45,
              backgroundColor: Colors.transparent,
              backgroundImage: _getProfileImage(),
              child: !hasImage
                  ? Icon(
                      isMember ? Icons.person_rounded : Icons.business_rounded,
                      size: 45,
                      color: AppColors.primary,
                    )
                  : null,
            ),
          ),
          // Verified badge
          if (companyInfos != null && companyInfos!.isValidated)
            Positioned(
              bottom: 4,
              right: 4,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: isDarkMode ? AppColors.darkBackground : Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.primary, AppColors.primaryDark],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, color: Colors.white, size: 12),
                ),
              ),
            ),
        ],
      ),
    );
  }

  ImageProvider? _getProfileImage() {
    if (isMember && memberInfos?.photoUrl != null) {
      return NetworkImage(memberInfos!.photoUrl!);
    }
    if (companyInfos != null && companyInfos!.logo.isNotEmpty) {
      return NetworkImage(companyInfos!.logo);
    }
    return null;
  }

  Widget _buildActionButtons(BuildContext context, bool isDarkMode) {
    if (isOwnProfile) {
      return EditProfileButton();
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ProfileActionButton(
          icon: FontAwesomeIcons.ellipsis,
          onPressed: () => ProfileUtils.showMoreOptions(context),
          isDarkMode: isDarkMode,
        ),
        const SizedBox(width: 8),
        ProfileActionButton(
          icon: FontAwesomeIcons.paperPlane,
          onPressed: () {},
          isDarkMode: isDarkMode,
        ),
        const SizedBox(width: 8),
       const FollowButton(),
      ],
    );
  }

  

}

class _DotPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.03)
      ..style = PaintingStyle.fill;

    const spacing = 30.0;
    const radius = 1.5;

    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
