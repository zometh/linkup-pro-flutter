import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linkup_pro/core/theme/app_colors.dart';
import 'package:linkup_pro/features/splash/providers/splash_provider.dart';

class PageIndicator extends ConsumerWidget {
  final double availableWidth;
  final double availableHeight;

  const PageIndicator({
    super.key,
    required this.availableWidth,
    required this.availableHeight,
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
              onTap: () =>
                  ref.read(splashProviderProvider.notifier).setIndex(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                width: indicatorProvider == index ? 20.0 : 8.0,
                height: 8.0,
                decoration: BoxDecoration(
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
