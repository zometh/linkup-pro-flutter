import 'package:flutter/material.dart';
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
      ],
    );
  }
}
