import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linkup_pro/core/widgets/custom_text.dart';

class BubbleActionTile extends StatelessWidget {
  final VoidCallback? onTap;
  final String title;
  final Color? color;
  final IconData? icon;
  final Color? iconColor;
  const BubbleActionTile({
    super.key,
    required this.title,
    this.onTap,
    this.color,
    this.icon,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: icon != null ? Icon(icon, color: iconColor) : null,
      title: CustomText(text: title.tr(), color: color),
      onTap: onTap,
    );
  }
}
