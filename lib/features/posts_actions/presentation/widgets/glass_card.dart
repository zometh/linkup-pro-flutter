import 'package:flutter/material.dart';

/// Carte avec effet glassmorphique et bordures asymétriques
/// pour un look plus naturel et moins généré par IA
class GlassCard extends StatelessWidget {
  final Widget child;
  final bool isDark;
  final EdgeInsets? padding;

  const GlassCard({
    super.key,
    required this.child,
    required this.isDark,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  Colors.white.withAlpha((0.055 * 255).round()),
                  Colors.white.withAlpha((0.035 * 255).round()),
                ]
              : [
                  Colors.white.withAlpha((0.93 * 255).round()),
                  Colors.white.withAlpha((0.82 * 255).round()),
                ],
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(18),
          topRight: Radius.circular(21),
          bottomLeft: Radius.circular(21),
          bottomRight: Radius.circular(19),
        ),
        border: Border.all(
          color: isDark
              ? Colors.white.withAlpha((0.075 * 255).round())
              : Colors.white.withAlpha((0.65 * 255).round()),
          width: 0.9,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withAlpha((0.22 * 255).round())
                : Colors.black.withAlpha((0.055 * 255).round()),
            blurRadius: 18,
            offset: const Offset(0.5, 5),
            spreadRadius: -2.5,
          ),
        ],
      ),
      child: child,
    );
  }
}
