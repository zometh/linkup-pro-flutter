import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:linkup_pro/main.dart';

class CustomText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color? color;
  final FontWeight fontWeight;
  final bool adaptColor;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final String? fontFamily;
  final FontStyle fontStyle;
  final TextDecoration? decoration;
  const CustomText({
    super.key,
    required this.text,
    this.fontSize = 15,
    this.color,
    this.fontWeight = FontWeight.normal,
    this.adaptColor = true,
    this.textAlign,
    this.maxLines,
    this.overflow = TextOverflow.visible,
    this.fontFamily,
    this.fontStyle = FontStyle.normal,
    this.decoration = TextDecoration.none,
  });

  @override
  Widget build(BuildContext context) {
    Color textColor =
        color ??
            (context.isDarkMode ? Colors.white : Colors.black87);

    return Text(
      text,

      style: GoogleFonts.getFont(
        fontFamily ?? "Poppins",
        fontSize: fontSize,
        color: textColor,
        fontWeight: fontWeight,
        fontStyle: fontStyle,
        decoration: decoration,
      ),

      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}
