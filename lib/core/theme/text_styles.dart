import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Helper class pour les styles de texte Manrope avec couleurs
class AppTextStyles {
  // Styles de titres - Mode clair
  static TextStyle get displayLarge => GoogleFonts.manrope(
    fontSize: 57,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.25,
    color: AppColors.textPrimary,
  );

  static TextStyle get displayMedium => GoogleFonts.manrope(
    fontSize: 45,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );

  static TextStyle get displaySmall => GoogleFonts.manrope(
    fontSize: 36,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );

  static TextStyle get headlineLarge => GoogleFonts.manrope(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static TextStyle get headlineMedium => GoogleFonts.manrope(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static TextStyle get headlineSmall => GoogleFonts.manrope(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  // Styles de titres de section
  static TextStyle get titleLarge => GoogleFonts.manrope(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    color: AppColors.textPrimary,
  );

  static TextStyle get titleMedium => GoogleFonts.manrope(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.15,
    color: AppColors.textPrimary,
  );

  static TextStyle get titleSmall => GoogleFonts.manrope(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    color: AppColors.textSecondary,
  );

  // Styles de corps de texte
  static TextStyle get bodyLarge => GoogleFonts.manrope(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
    color: AppColors.textPrimary,
  );
  // BodyMedium is used for general text content
  static TextStyle get bodyMedium => GoogleFonts.manrope(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
    color: AppColors.textSecondary,
  );
  // BodySmall is used for secondary text content
  static TextStyle get bodySmall => GoogleFonts.manrope(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
    color: AppColors.textTertiary,
  );

  // Styles de texte pour les labels et boutons
  static TextStyle get labelLarge => GoogleFonts.manrope(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    color: AppColors.textPrimary,
  );

  static TextStyle get labelMedium => GoogleFonts.manrope(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    color: AppColors.textSecondary,
  );

  static TextStyle get labelSmall => GoogleFonts.manrope(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    color: AppColors.textTertiary,
  );

  static TextStyle get button => GoogleFonts.manrope(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
    color: Colors.white,
  );

  static TextStyle get caption => GoogleFonts.manrope(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
    color: AppColors.textTertiary,
  );

  static TextStyle get overline => GoogleFonts.manrope(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    letterSpacing: 1.5,
    color: AppColors.textTertiary,
  );

  static TextStyle get logo => GoogleFonts.manrope(
    fontSize: 24,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.5,
    color: AppColors.primary,
  );

  static TextStyle get subtitle => GoogleFonts.manrope(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    letterSpacing: 0,
    color: AppColors.textSecondary,
  );

  // === STYLES POUR MODE SOMBRE ===

  // Styles de titres - Mode sombre
  static TextStyle get displayLargeDark =>
      displayLarge.copyWith(color: Colors.white);
  static TextStyle get displayMediumDark =>
      displayMedium.copyWith(color: Colors.white);
  static TextStyle get displaySmallDark =>
      displaySmall.copyWith(color: Colors.white);
  static TextStyle get headlineLargeDark =>
      headlineLarge.copyWith(color: Colors.white);
  static TextStyle get headlineMediumDark =>
      headlineMedium.copyWith(color: Colors.white);
  static TextStyle get headlineSmallDark =>
      headlineSmall.copyWith(color: Colors.white);

  // Styles de titres de section - Mode sombre
  static TextStyle get titleLargeDark =>
      titleLarge.copyWith(color: Colors.white);
  static TextStyle get titleMediumDark =>
      titleMedium.copyWith(color: Colors.white);
  static TextStyle get titleSmallDark =>
      titleSmall.copyWith(color: Colors.white70);

  // Styles de corps de texte - Mode sombre
  static TextStyle get bodyLargeDark => bodyLarge.copyWith(color: Colors.white);
  static TextStyle get bodyMediumDark =>
      bodyMedium.copyWith(color: Colors.white70);
  static TextStyle get bodySmallDark =>
      bodySmall.copyWith(color: Colors.white60);

  // Styles de labels - Mode sombre
  static TextStyle get labelLargeDark =>
      labelLarge.copyWith(color: Colors.white);
  static TextStyle get labelMediumDark =>
      labelMedium.copyWith(color: Colors.white70);
  static TextStyle get labelSmallDark =>
      labelSmall.copyWith(color: Colors.white60);

  // Autres styles - Mode sombre
  static TextStyle get captionDark => caption.copyWith(color: Colors.white60);
  static TextStyle get overlineDark => overline.copyWith(color: Colors.white60);
  static TextStyle get subtitleDark => subtitle.copyWith(color: Colors.white70);
  // Le logo et button gardent leurs couleurs respectives (primary et white)
}

/// Helper pour obtenir les styles selon le thème actuel
class AppTextStylesThemed {
  /// Obtient le style approprié selon le thème (clair/sombre)
  static TextStyle getDisplayLarge(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? AppTextStyles.displayLargeDark
        : AppTextStyles.displayLarge;
  }

  static TextStyle getDisplayMedium(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? AppTextStyles.displayMediumDark
        : AppTextStyles.displayMedium;
  }

  static TextStyle getDisplaySmall(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? AppTextStyles.displaySmallDark
        : AppTextStyles.displaySmall;
  }

  static TextStyle getHeadlineLarge(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? AppTextStyles.headlineLargeDark
        : AppTextStyles.headlineLarge;
  }

  static TextStyle getHeadlineMedium(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? AppTextStyles.headlineMediumDark
        : AppTextStyles.headlineMedium;
  }

  static TextStyle getHeadlineSmall(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? AppTextStyles.headlineSmallDark
        : AppTextStyles.headlineSmall;
  }

  static TextStyle getTitleLarge(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? AppTextStyles.titleLargeDark
        : AppTextStyles.titleLarge;
  }

  static TextStyle getTitleMedium(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? AppTextStyles.titleMediumDark
        : AppTextStyles.titleMedium;
  }

  static TextStyle getTitleSmall(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? AppTextStyles.titleSmallDark
        : AppTextStyles.titleSmall;
  }

  static TextStyle getBodyLarge(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? AppTextStyles.bodyLargeDark
        : AppTextStyles.bodyLarge;
  }

  static TextStyle getBodyMedium(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? AppTextStyles.bodyMediumDark
        : AppTextStyles.bodyMedium;
  }

  static TextStyle getBodySmall(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? AppTextStyles.bodySmallDark
        : AppTextStyles.bodySmall;
  }

  static TextStyle getSubtitle(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? AppTextStyles.subtitleDark
        : AppTextStyles.subtitle;
  }

  static TextStyle getCaption(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? AppTextStyles.captionDark
        : AppTextStyles.caption;
  }

  // Le logo et button gardent leurs styles fixes
  static TextStyle get logo => AppTextStyles.logo;
  static TextStyle get button => AppTextStyles.button;
}

/// Extension pour appliquer facilement les couleurs aux styles de texte
extension AppTextStylesExtension on TextStyle {
  TextStyle withColor(Color color) => copyWith(color: color);
  TextStyle withWeight(FontWeight weight) => copyWith(fontWeight: weight);
  TextStyle withSize(double size) => copyWith(fontSize: size);
  TextStyle withOpacity(double opacity) =>
      copyWith(color: color?.withAlpha((opacity * 255).toInt()));
}
