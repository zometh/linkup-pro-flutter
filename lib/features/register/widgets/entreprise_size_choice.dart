import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:linkup_pro/core/theme/app_colors.dart';
import 'package:linkup_pro/features/register/data/entities/entreprise.dart';
import 'package:linkup_pro/main.dart';

class EntrepriseSizeChoice extends StatelessWidget {
  final CompanySize initialSelection;
  final Function(CompanySize)? onSizeSelected;
  const EntrepriseSizeChoice({
    super.key,
    required this.initialSelection,
    this.onSizeSelected,
  });

  @override
  Widget build(BuildContext context) {
    final avaiblewidth = MediaQuery.sizeOf(context).width;
    final List<String> sizes = [
      "small_business",
      "medium_business",
      "large_business",
    ];
    return DropdownMenu(
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: context.isDarkMode
            ? Color(0xFF1E293B).withValues(
                alpha: .5,
              ) // Gris foncé semi-transparent en mode sombre
            : AppColors.primary.withValues(alpha: .03),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        hintStyle: GoogleFonts.getFont(
          'Poppins',
          textStyle: TextStyle(
            color: context.isDarkMode
                ? Colors.white70
                : AppColors.textSecondary,
            fontSize: 14,
          ),
        ),
      ),
      width: avaiblewidth * 0.8,
      menuStyle: MenuStyle(
        backgroundColor: WidgetStatePropertyAll(
          AppColors.primary /*.withValues(alpha: .03)*/,
        ),
        elevation: WidgetStatePropertyAll(4),
        surfaceTintColor: WidgetStatePropertyAll(
          context.isDarkMode
              ? Color(0xFF1E293B).withValues(
                  alpha: .5,
                ) // Gris foncé semi-transparent en mode sombre
              : AppColors.primary.withValues(alpha: .03),
        ),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
      leadingIcon: const Icon(Icons.person, color: AppColors.primary),
      initialSelection: _mapEnumToChoice(initialSelection),
      dropdownMenuEntries: sizes
          .map(
            (size) => DropdownMenuEntry(
              value: size,
              label: size.tr(),
              labelWidget: Text(
                size.tr(),
                style: GoogleFonts.getFont(
                  'Poppins',
                  textStyle: TextStyle(
                    color: Colors.white, // <--- forcé en blanc
                    fontSize: 14,
                  ),
                ),
              ),
              style: ButtonStyle(
                textStyle: WidgetStatePropertyAll(
                  GoogleFonts.getFont(
                    'Poppins',
                    textStyle: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
              ),
            ),
          )
          .toList(),

      onSelected: (String? choice) {
        if (choice != null && onSizeSelected != null) {
          onSizeSelected!(_mapChoiceToEnum(choice));
        }
      },
    );
  }

  CompanySize _mapChoiceToEnum(String choice) {
    switch (choice) {
      case "small_business":
        return CompanySize.small;
      case "medium_business":
        return CompanySize.medium;
      case "large_business":
        return CompanySize.large;
      default:
        return CompanySize.small;
    }
  }

  String _mapEnumToChoice(CompanySize size) {
    switch (size) {
      case CompanySize.small:
        return "small_business";
      case CompanySize.medium:
        return "medium_business";
      case CompanySize.large:
        return "large_business";
    }
  }
}
