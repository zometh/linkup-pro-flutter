import 'package:flutter/material.dart';
import 'package:linkup_pro/main.dart';

import '../../../core/utils/assets_path.dart';

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
