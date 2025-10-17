import 'package:flutter/material.dart';
import 'package:linkup_pro/core/utils/services/assets_path.dart';
import 'package:linkup_pro/main.dart';

class CustomProgress extends StatefulWidget {
  const CustomProgress({super.key});

  @override
  State<CustomProgress> createState() => _CustomProgressState();
}

class _CustomProgressState extends State<CustomProgress>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _pulseController;
  late AnimationController _glowController;
  late Animation<double> _rotationAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();

    // Animation de rotation
    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
    _rotationAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _rotationController, curve: Curves.linear),
    );

    // Animation de pulsation
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Animation de lueur
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);
    _glowAnimation = Tween<double>(begin: 0.3, end: 0.8).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _pulseController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: AnimatedBuilder(
        animation: Listenable.merge([
          _rotationAnimation,
          _pulseAnimation,
          _glowAnimation,
        ]),
        builder: (context, child) {
          return Transform.scale(
            scale: _pulseAnimation.value,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Cercle extérieur animé
                Container(
                  width: context.screenWidth * 0.25,
                  height: context.screenWidth * 0.25,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        colorScheme.primary.withValues(
                          alpha: _glowAnimation.value * 0.3,
                        ),
                        colorScheme.primary.withValues(alpha: 0.0),
                      ],
                    ),
                  ),
                ),

                // Cercle de lueur pulsant
                Container(
                  width: context.screenWidth * 0.18,
                  height: context.screenWidth * 0.18,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: colorScheme.primary.withValues(
                          alpha: _glowAnimation.value * 0.5,
                        ),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),

                // Logo rotatif avec fond
                Container(
                  width: context.screenWidth * 0.15,
                  height: context.screenWidth * 0.15,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colorScheme.surface,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Transform.rotate(
                    angle: _rotationAnimation.value * 6.283185307179586,
                    child: Padding(
                      padding: EdgeInsets.all(context.screenWidth * 0.025),
                      child: Image.asset(
                        AssetsPath.logoOnly,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),

                // Points indicateurs rotatifs
                ...List.generate(3, (index) {
                  final angle =
                      (index * 2 * 3.141592653589793 / 3) +
                      (_rotationAnimation.value * 6.283185307179586);
                  final radius = context.screenWidth * 0.11;
                  final x =
                      radius *
                      (1 + 0.8 * (index / 2)) *
                      (index.isEven ? 1 : -1) *
                      _pulseAnimation.value;
                  final y =
                      radius *
                      (1 + 0.8 * (index / 2)) *
                      (index.isEven ? 1 : -1) *
                      _pulseAnimation.value;

                  return Transform.translate(
                    offset: Offset(
                      x * (index.isEven ? 1 : -1),
                      y * (index.isOdd ? 1 : -1),
                    ),
                    child: Container(
                      width: 8 - (index * 1.5),
                      height: 8 - (index * 1.5),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: colorScheme.primary.withValues(
                          alpha: 1.0 - (index * 0.2),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: colorScheme.primary.withValues(alpha: 0.5),
                            blurRadius: 4,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          );
        },
      ),
    );
  }
}
