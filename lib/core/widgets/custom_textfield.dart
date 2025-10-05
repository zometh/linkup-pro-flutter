import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.type = TextFieldType.normal,
    this.validator,
    this.formatter,
    this.filled = true,
    this.prefixIcon,

    this.borderRadius = 15,
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
    final isDark = context.isDarkMode;

    // Utilisation des couleurs de l'application
    final fillColor = isDark
        ? AppColors.darkInput
        : AppColors.lightSurface.withAlpha(50);

    final borderColor = isDark ? Colors.white10 : AppColors.lightBorder;

    final focusedBorderColor = AppColors.primary;

    final hintColor = isDark ? AppColors.textTertiary : AppColors.textSecondary;

    return TextFormField(
      autocorrect: true,
      enableSuggestions: true,

      cursorColor: AppColors.primary,
      onTapOutside: (event) => FocusScope.of(context).unfocus(),
      maxLines: widget.maxLines,
      controller: widget.controller,
      validator: widget.validator,
      obscureText: widget.type == TextFieldType.password && isHidden,
      inputFormatters: widget.formatter != null ? [widget.formatter!] : null,
      style: TextStyle(color: isDark ? Colors.white : AppColors.textPrimary),
      onChanged: widget.type == TextFieldType.password
          ? (value) => setState(() => textLength = value.length)
          : null,
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: TextStyle(color: hintColor),
        filled: widget.filled,
        fillColor: widget.filled ? fillColor : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: BorderSide(
            color: widget.filled ? borderColor : AppColors.lightBorder,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: BorderSide(
            color: focusedBorderColor,
            width: 2.0, // Épaisseur plus importante pour le focus
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: BorderSide(color: AppColors.error, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: BorderSide(color: AppColors.error, width: 2.0),
        ),
        suffixIcon: _buildSuffixIcon(isDark),
        prefixIcon: widget.prefixIcon != null
            ? Icon(
                widget.prefixIcon,
                color: isDark
                    ? AppColors.textTertiary
                    : AppColors.textSecondary,
              )
            : null,
      ),
    );
  }

  Widget? _buildSuffixIcon(bool isDark) {
    if (widget.type == TextFieldType.password && textLength > 0) {
      return IconButton(
        onPressed: () => setState(() => isHidden = !isHidden),
        icon: Icon(
          isHidden ? CupertinoIcons.eye : CupertinoIcons.eye_slash,
          size: widget.maxWidth! * 0.04,
          color: isDark ? AppColors.textTertiary : AppColors.textSecondary,
        ),
      );
    }
    return null;
  }
}
