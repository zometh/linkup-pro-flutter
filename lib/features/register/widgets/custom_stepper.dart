import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linkup_pro/core/theme/app_colors.dart';
import 'package:linkup_pro/features/register/presentation/providers/stepper.dart';

class CustomStepper extends ConsumerWidget {

  const CustomStepper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(builder: (_, constraints) {
      final step = ref.watch(stepperProvider);
      return Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(3, (index) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 8.0),
            width: constraints.maxWidth / 3.5,
            height: constraints.maxHeight * 0.3,
            decoration: BoxDecoration(
              color: index == step ? AppColors.primary : Colors.grey[300],
              borderRadius: BorderRadius.circular(4.0),
            ),
          ).animate().fadeIn(duration: 300.ms, delay: (index * 100).ms);
        }),
      );
    });
  }
}


