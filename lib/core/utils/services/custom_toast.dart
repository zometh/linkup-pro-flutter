import 'package:flutter/material.dart';
import 'package:linkup_pro/core/widgets/custom_text.dart';
import 'package:toastification/toastification.dart';

void showToast({
  ToastificationType type = ToastificationType.info,
  ToastificationStyle style = ToastificationStyle.fillColored,
  required String description,
  Duration  autoCloseDuration = const Duration(seconds: 5),
  double borderRadius = 12,
  bool showProgressBar = true,
  bool closeOnClick = false,
  bool pauseOnHover = true,
  bool dragToClose = true,
  bool applyBlurEffect = true,
  Duration animationDuration = const Duration(milliseconds: 300),
  TextDirection direction = TextDirection.ltr,
  Alignment alignment = Alignment.topRight,
  Icon icon = const Icon(Icons.check, color: Colors.white,),
  bool showIcon = false,
}) {
  toastification.show(
    type: type,
    style: style,
    title: CustomText(text: description,fontSize: 12, fontWeight: FontWeight.w400,),
    //description: Text(description) /*CustomText(text: description)*/,
    autoCloseDuration: autoCloseDuration,
    borderRadius: BorderRadius.all(Radius.circular(borderRadius.toDouble())),
    showProgressBar: showProgressBar,
    closeOnClick: closeOnClick,
    pauseOnHover: pauseOnHover,
    dragToClose: dragToClose,
    applyBlurEffect: applyBlurEffect,
    animationDuration: animationDuration,
    direction: direction,
    alignment: alignment,
    icon: icon,
    showIcon: showIcon,
  );
}
