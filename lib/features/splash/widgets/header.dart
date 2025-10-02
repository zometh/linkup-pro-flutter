import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linkup_pro/core/theme/theme.dart';
import 'package:linkup_pro/core/utils/services/assets_path.dart';
import 'package:linkup_pro/main.dart';

class SplashHeader extends StatelessWidget {
  const SplashHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Image.asset(AssetsPath.logo, height: context.isMobile ? 40 : 60),
        TextButton(
          onPressed: () {
            // Navigate to login page
          },
          child: Text(
            'skip',
            style: AppTextStyles.bodyMedium.copyWith(
              color: context.isDarkMode ? Colors.white70 : Colors.black87,
            ),
          ).tr(),
        ),
      ],
    );
  }
}
