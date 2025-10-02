import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linkup_pro/core/theme/app_colors.dart';
import 'package:linkup_pro/features/splash/providers/splash_provider.dart';

class PageIndicator extends ConsumerWidget {
  final double availableWidth;
  final double availableHeight;
  final PageController pageController;

  const PageIndicator({
    super.key,
    required this.availableWidth,
    required this.availableHeight,
    required this.pageController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // If it's a simple provider:
    final indicatorProvider = ref.watch(splashProviderProvider);

    // If it's a StateNotifierProvider or similar:
    // final indicatorProvider = ref.watch(splashProvider.notifier);

    // If you need just the state:
    // final indicatorState = ref.watch(splashProvider);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: List.generate(3, (index) {
            return InkWell(
              hoverColor: Colors.transparent,
              overlayColor: WidgetStatePropertyAll(Colors.transparent),
              onTap: (){
                ref.read(splashProviderProvider.notifier).setIndex(index);
                pageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                width: indicatorProvider == index ? 25.0 : 9.0,
                height: 9.0,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(10),
                      blurRadius: 4.0,
                      offset: const Offset(0, 2),
                    ),
                  ],
                  color: indicatorProvider == index ? Colors.blue : Colors.grey,
                  borderRadius: BorderRadius.circular(4.0),
                ),
              ),
            );
          }),
        ),
        Container(
          width: availableWidth * 0.13,
          height: availableHeight * 0.13,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(20),
                blurRadius: 6.0,
                offset: const Offset(0, 3),
              ),
            ],
            shape: BoxShape.circle,
            color: AppColors.primary,
          ),
          child: Icon(
            Icons.arrow_forward,
            color: Colors.white,
            size: availableHeight * 0.03,
          ),
        ),
      ],
    );
  }
}
