import 'package:flutter/material.dart';
import 'package:linkup_pro/core/theme/theme.dart';
import 'package:linkup_pro/core/utils/formatters/fomat_text.dart';
import 'package:linkup_pro/core/widgets/custom_text.dart';

class CustomButton extends StatelessWidget {
  final Function() onPressed;
  final double fontSize;
  final IconData? icon;
  final String text;
  final Color color;
  final double? width;
  final double height;
  final double borderRadius;
  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.fontSize = 20,
    this.icon,
    this.color = AppColors.primary,
    this.width,
    this.height = 50,
    this.borderRadius = 10,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(

      overlayColor: WidgetStatePropertyAll(Colors.transparent),
      hoverColor: Colors.red,
      onTap: onPressed,
      child: Card(
        elevation: 1,
        color: Colors
            .transparent,
        child: Container(
          width: width ?? double.infinity,
          height: height,
          decoration: BoxDecoration(
            //backgroundBlendMode: BlendMode.darken,
            color: color,
            gradient: AppGradients.primaryGradient,
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: Center(
            child: icon != null
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 4,
                    children: [
                      CustomText(
                        text: FormatText.formatTitle(text),
                        color: Colors.white,
                        adaptColor: false,
                        fontWeight: FontWeight.bold,
                        fontSize: fontSize,
                      ),
                      Icon(icon, color: Colors.white),
                    ],
                  )
                : CustomText(
                    text: FormatText.formatTitle(text),
                    color: Colors.white,
                    adaptColor: false,
                    fontWeight: FontWeight.bold,
                    fontSize: fontSize,
                  ),
          ),
        ),
      ),
    );
  }
}
