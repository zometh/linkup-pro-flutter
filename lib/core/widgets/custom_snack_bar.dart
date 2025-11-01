import 'package:flutter/material.dart';
import 'package:linkup_pro/core/theme/theme.dart';
import 'package:linkup_pro/core/widgets/custom_text.dart';
showSnackBar(
  BuildContext context, {
  required String message,
  bool isError = false,
}) {
  final snackBar = SnackBar(
    behavior: SnackBarBehavior.floating,
    content: CustomText(text: message, color: Colors.white, fontSize: 13,),
    showCloseIcon: true,
    closeIconColor: Colors.white  ,
    backgroundColor: isError ? Colors.red : AppColors.primary,
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}