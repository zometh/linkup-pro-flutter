import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:linkup_pro/core/enums/textfield_type.dart';
import 'package:linkup_pro/core/theme/app_colors.dart';
import 'package:linkup_pro/main.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final TextFieldType type;
  final FormFieldValidator<String>? validator;
  final TextInputFormatter? formatter;
  final bool filled;
  final IconData? prefixIcon;
  final double borderRadius;
  final int maxLines;
  final double? maxHeight;
  final double? maxWidth;
  final double? maxLength;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.type = TextFieldType.normal,
    this.validator,
    this.formatter,
    this.filled = true,
    this.prefixIcon,
    this.maxLength,
    this.borderRadius = 10
    ,
    this.maxLines = 1,
    this.maxHeight,
    this.maxWidth,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool isHidden = true;
  int textLength = 0;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: widget.maxHeight ?? double.infinity,
        maxWidth: widget.maxWidth ?? double.infinity,
      ),
      child: TextFormField(
        maxLength: widget.maxLength?.toInt(),
        autocorrect: true,
        enableSuggestions: true,
        onChanged: (value) => setState(() => textLength = value.length),
        cursorColor: AppColors.primary,
        onTapOutside: (event) => FocusScope.of(context).unfocus(),
        maxLines: widget.maxLines,
        controller: widget.controller,
        validator: widget.validator,
        obscureText: widget.type == TextFieldType.password && isHidden,
        inputFormatters: widget.formatter != null ? [widget.formatter!] : null,
        style: GoogleFonts.getFont('Poppins',
            textStyle: TextStyle(color: context.isDarkMode ? Colors.white : AppColors.textPrimary, fontSize: 14)),
        decoration: InputDecoration(
          filled: true,
          fillColor: context.isDarkMode
              ? Color(0xFF1E293B).withValues(alpha: .5) // Gris foncé semi-transparent en mode sombre
              : AppColors.primary.withValues(alpha: .03), // Teinte primaire très légère en mode clair
          hintText: widget.hintText,
          hintStyle: GoogleFonts.poppins(
            color: context.isDarkMode
                ? Colors.grey[400]
                : Colors.grey[600],
            fontSize: 14,
          ),
          prefixIcon: widget.prefixIcon != null
              ? Icon(
                  widget.prefixIcon,
                  color: context.isDarkMode
                      ? AppColors.primary.withValues(alpha: .7)
                      : AppColors.primary.withValues(alpha: .6),
                  size: 20,
                )
              : null,
          suffixIcon: _buildSuffixIcon(context),
          isDense: true,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: context.isDarkMode
                  ? Colors.grey[700]!
                  : Colors.grey[300]!,
              width: 1,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: context.isDarkMode
                  ? Colors.grey[700]!.withValues(alpha: .3)
                  : Colors.grey[300]!,
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: AppColors.primary,
              width: 2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Colors.red[400]!,
              width: 1.5,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Colors.red[400]!,
              width: 2,
            ),
          ),
        ),
      ),
    );
  }

  Widget? _buildSuffixIcon(BuildContext context) {
    if (widget.type == TextFieldType.password && textLength > 0) {
      return IconButton(
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
        onPressed: () => setState((){
          isHidden = !isHidden;
        }),
        icon: Icon(
          isHidden ? CupertinoIcons.eye : CupertinoIcons.eye_slash,
          size: 20,
          color: context.isDarkMode ? Colors.white : AppColors.textSecondary,
        ),
      );
    }
    return null;
  }
}
