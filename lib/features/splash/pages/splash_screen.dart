import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:linkup_pro/core/utils/services/assets_path.dart';
import 'package:linkup_pro/core/widgets/custom_text.dart';
import 'package:linkup_pro/features/splash/providers/splash_provider.dart';
import 'package:linkup_pro/features/splash/widgets/header.dart';
import 'package:linkup_pro/features/splash/widgets/page_indicator.dart';

import '../../../core/utils/services/localdb.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  late PageController _pageController;
  final service = GetIt.I<LocalDBService>();
  @override
  void initState() {
    _pageController = PageController(initialPage: 0);

    super.initState();
  }
  @override
  void didChangeDependencies() {

    super.didChangeDependencies();

  }

  @override
  void dispose() {

    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {


    final List<String> splashImages = [
      AssetsPath.splash1,
      AssetsPath.splash2,
      AssetsPath.splash3,
    ];
    final List<String> splashTitles = [
      'text_splash_1',
      'text_splash_2',
      'text_splash_3',
    ];
    final List<String> splashSubtitles = [
      'splash_subtitle_1',
      'splash_subtitle_2',
      'splash_subtitle_3',
    ];
   // print(context.locale.languageCode);
    return Scaffold(

      appBar: AppBar(title: SplashHeader()),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Padding(
            padding: EdgeInsets.all(constraints.maxWidth * 0.035),
            child: Column(
              children: [
                Expanded(
                  flex: 8,
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (index) {
                      ref.read(splashProviderProvider.notifier).setIndex(index);
                    },
                    children: List.generate(splashImages.length, (index) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            flex: 4,
                            child: Image.asset(
                              splashImages[index],
                              fit: BoxFit.contain,
                              filterQuality: FilterQuality.high,
                            ),
                          ),
                          SizedBox(height: constraints.maxHeight * 0.02),
                          CustomText(

                            text:splashTitles[index].tr(),

                                  fontWeight: FontWeight.bold,
                                  fontSize: constraints.maxWidth * 0.068,

                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: constraints.maxHeight * 0.017),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: constraints.maxWidth * 0.01,
                            ),
                            child: CustomText(
                              text :splashSubtitles[index].tr(),
                              textAlign: TextAlign.center ,
                              fontSize: constraints.maxWidth * 0.039,
                              fontWeight: FontWeight.w300,
                              fontFamily: "Manrope",
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: PageIndicator(
                    availableHeight: constraints.maxHeight,
                    availableWidth: constraints.maxWidth,
                    pageController: _pageController,
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
