import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:linkup_pro/main.dart';

import '../utils/assets_path.dart';

class CustomProgress extends StatefulWidget {
  const CustomProgress({super.key});

  @override
  State<CustomProgress> createState() => _CustomProgressState();
}

class _CustomProgressState extends State<CustomProgress>
    with TickerProviderStateMixin {
  late AnimationController _spinController;
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _spinController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.92, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _spinController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: AnimatedBuilder(
        animation: Listenable.merge([_spinController, _scaleController]),
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: SizedBox(
              width: context.screenWidth * 0.2,
              height: context.screenWidth * 0.2,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Cercles animés en rotation
                  CustomPaint(
                    size: Size(
                      context.screenWidth * 0.2,
                      context.screenWidth * 0.2,
                    ),
                    painter: _CircularProgressPainter(
                      progress: _spinController.value,
                      color: colorScheme.primary,
                    ),
                  ),

                  // Logo central
                  Container(
                    width: context.screenWidth * 0.12,
                    height: context.screenWidth * 0.12,
                    padding: EdgeInsets.all(context.screenWidth * 0.02),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: colorScheme.surface,
                      boxShadow: [
                        BoxShadow(
                          color: colorScheme.primary.withValues(alpha: 0.2),
                          blurRadius: 12,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Image.asset(
                      AssetsPath.logoOnly,
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _CircularProgressPainter extends CustomPainter {
  final double progress;
  final Color color;

  _CircularProgressPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Arc principal
    final paint1 = Paint()
      ..color = color.withValues(alpha: 0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;

    final sweepAngle1 = math.pi * 0.6;
    final startAngle1 = progress * 2 * math.pi;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - 4),
      startAngle1,
      sweepAngle1,
      false,
      paint1,
    );

    // Arc secondaire (opposé)
    final paint2 = Paint()
      ..color = color.withValues(alpha: 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    final sweepAngle2 = math.pi * 0.4;
    final startAngle2 = progress * 2 * math.pi + math.pi;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - 4),
      startAngle2,
      sweepAngle2,
      false,
      paint2,
    );

    // Points décoratifs
    for (int i = 0; i < 3; i++) {
      final angle = (progress * 2 * math.pi) + (i * 2 * math.pi / 3);
      final dotRadius = radius - 2;
      final dotX = center.dx + dotRadius * math.cos(angle);
      final dotY = center.dy + dotRadius * math.sin(angle);

      final dotPaint = Paint()
        ..color = color.withValues(alpha: 0.8 - (i * 0.2))
        ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(dotX, dotY), 3.0 - (i * 0.5), dotPaint);
    }
  }

  @override
  bool shouldRepaint(_CircularProgressPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
