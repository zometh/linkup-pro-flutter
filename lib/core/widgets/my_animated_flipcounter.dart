import 'package:flutter/material.dart';
import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:linkup_pro/main.dart';

import '../theme/app_colors.dart';
import '../utils/formatters/format_number.dart';


class MyAnimatedFlipcounter extends StatelessWidget {
  final Color? color;
  final double fontSize;
  final int value;
  const MyAnimatedFlipcounter({super.key, required this.value, this.fontSize = 16, this.color});

  @override
  Widget build(BuildContext context) {
    final reactionsData = FormatNumber.formatReactions(value);
    final buttonColor = color??  (context.isDarkMode ? Colors.white70 : AppColors.textSecondary);
    return AnimatedFlipCounter(
      value: reactionsData['value'],
      fractionDigits: reactionsData['suffix'] != '' ? 1 : 0,
      suffix: reactionsData['suffix'],
      duration: Duration(milliseconds: 500),
      textStyle: GoogleFonts.manrope(
        fontSize: fontSize,
        fontWeight: FontWeight.w600,
        color: buttonColor,
      ),
    );
  }
}
