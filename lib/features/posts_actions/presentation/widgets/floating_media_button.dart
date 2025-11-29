import 'package:flutter/material.dart';

/// Bouton flottant avec emojis optionnels et style asymétrique
/// Utilisé pour les actions médias (galerie, caméra)
class FloatingMediaButton extends StatelessWidget {
  final String? emoji;
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final ThemeData theme;
  final bool isDark;

  const FloatingMediaButton({
    super.key,
    this.emoji,
    required this.icon,
    required this.label,
    required this.onTap,
    required this.theme,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(14),
          bottomLeft: Radius.circular(14),
          bottomRight: Radius.circular(13),
        ),
        child: Container(
          padding: const EdgeInsets.fromLTRB(11, 8, 12, 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                theme.colorScheme.primary.withValues(alpha: 0.11),
                theme.colorScheme.primary.withValues(alpha: 0.055),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(14),
              bottomLeft: Radius.circular(14),
              bottomRight: Radius.circular(13),
            ),
            border: Border.all(
              color: theme.colorScheme.primary.withValues(alpha: 0.18),
              width: 0.75,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (emoji != null) ...[
                Text(emoji!, style: const TextStyle(fontSize: 14)),
                const SizedBox(width: 6),
              ] else
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.13),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(icon, size: 14, color: theme.colorScheme.primary),
                ),
              if (emoji == null) const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: theme.colorScheme.primary.withValues(alpha: 0.9),
                  letterSpacing: 0.15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
