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

class _SplashScreenState extends ConsumerState<SplashScreen>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  final service = GetIt.I<LocalDBService>();

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeOutBack),
    );

    _fadeController.forward();
    _scaleController.forward();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fadeController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    ref.read(splashProviderProvider.notifier).setIndex(index);
    _fadeController.reset();
    _scaleController.reset();
    _fadeController.forward();
    _scaleController.forward();
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

    ref.watch(splashProviderProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: SplashHeader(),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).scaffoldBackgroundColor,
              Theme.of(context).primaryColor.withValues(alpha: 0.05),
              Theme.of(context).scaffoldBackgroundColor,
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: constraints.maxWidth * 0.05,
                  vertical: constraints.maxHeight * 0.02,
                ),
                child: Column(
                  children: [
                    Expanded(
                      flex: 9,
                      child: PageView.builder(
                        controller: _pageController,
                        onPageChanged: _onPageChanged,
                        itemCount: splashImages.length,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return AnimatedBuilder(
                            animation: _fadeAnimation,
                            builder: (context, child) {
                              return FadeTransition(
                                opacity: _fadeAnimation,
                                child: ScaleTransition(
                                  scale: _scaleAnimation,
                                  child: child,
                                ),
                              );
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Flexible(
                                  flex: 5,
                                  child: Hero(
                                    tag: 'splash_image_$index',
                                    child: Container(
                                      padding: EdgeInsets.all(
                                        constraints.maxWidth * 0.08,
                                      ),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: RadialGradient(
                                          colors: [
                                            Theme.of(
                                              context,
                                            ).primaryColor.withValues(alpha: .1),
                                            Colors.transparent,
                                          ],
                                        ),
                                      ),
                                      child: Image.asset(
                                        splashImages[index],
                                        fit: BoxFit.contain,
                                        filterQuality: FilterQuality.high,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: constraints.maxHeight * 0.04),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: constraints.maxWidth * 0.08,
                                  ),
                                  child: Column(
                                    children: [
                                      CustomText(
                                        text: splashTitles[index].tr(),
                                        fontWeight: FontWeight.bold,
                                        fontSize: constraints.maxWidth * 0.07,
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(
                                        height: constraints.maxHeight * 0.02,
                                      ),
                                      CustomText(
                                        text: splashSubtitles[index].tr(),
                                        textAlign: TextAlign.center,
                                        fontSize: constraints.maxWidth * 0.042,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: "Manrope",
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.color
                                            ?.withValues(alpha: .7),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: constraints.maxHeight * 0.02),
                    Expanded(
                      flex: 2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          PageIndicator(
                            availableHeight: constraints.maxHeight,
                            availableWidth: constraints.maxWidth,
                            pageController: _pageController,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
