import 'package:flutter/material.dart';

/// Compteur de caractères premium avec indicateur circulaire
/// Affiche les caractères restants avec un style visuel attrayant
class CharacterCounter extends StatelessWidget {
  final int remaining;
  final ThemeData theme;
  final double progress;
  final bool isDark;

  const CharacterCounter({
    super.key,
    required this.remaining,
    required this.theme,
    required this.progress,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final Color baseColor = remaining < 0
        ? theme.colorScheme.error
        : remaining < 20
        ? const Color(0xFFFF9500)
        : theme.colorScheme.primary;

    return Container(
      padding: const EdgeInsets.fromLTRB(10, 7, 11, 7),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            baseColor.withValues(alpha: 0.11),
            baseColor.withValues(alpha: 0.055),
          ],
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(14),
          topRight: Radius.circular(16),
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(15),
        ),
        border: Border.all(
          color: baseColor.withValues(alpha: 0.25),
          width: 0.85,
        ),
        boxShadow: [
          BoxShadow(
            color: baseColor.withValues(alpha: 0.15),
            blurRadius: 7,
            offset: const Offset(0.5, 2.5),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (remaining <= 50)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: baseColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '$remaining',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: baseColor,
                  ),
                ),
              ),
            ),
          SizedBox(
            width: 24,
            height: 24,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 2.5,
                  backgroundColor: isDark
                      ? Colors.white.withValues(alpha: 0.08)
                      : Colors.black.withValues(alpha: 0.06),
                  valueColor: AlwaysStoppedAnimation<Color>(baseColor),
                ),
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: [baseColor, baseColor.withValues(alpha: 0.6)],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: baseColor.withValues(alpha: 0.6),
                        blurRadius: 6,
                        spreadRadius: 0.5,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
