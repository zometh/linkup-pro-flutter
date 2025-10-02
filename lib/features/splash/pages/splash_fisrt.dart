import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linkup_pro/core/utils/services/assets_path.dart';
import 'package:linkup_pro/features/splash/widgets/header.dart';
import 'package:linkup_pro/features/splash/widgets/page_indicator.dart';

class SplashFisrt extends StatelessWidget {
  const SplashFisrt({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const SplashHeader()),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Padding(
            padding: EdgeInsets.all(constraints.maxWidth * 0.035),
            child: Column(
              spacing: constraints.maxHeight * 0.002,
              children: [
                Image.asset(AssetsPath.splash1),
                Text(
                  'text_splash_1',
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: constraints.maxWidth * 0.065,
                  ),
                  textAlign: TextAlign.center,
                ).tr(),
                SizedBox(height: constraints.maxHeight * 0.01),
                Text(
                  "splash_subtitle_1",
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontSize: constraints.maxWidth * 0.038,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ).tr(),
                Expanded(
                  child: PageIndicator(
                    availableHeight: constraints.maxHeight,
                    availableWidth: constraints.maxWidth,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
