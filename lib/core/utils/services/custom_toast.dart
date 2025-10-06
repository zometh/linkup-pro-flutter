import 'package:flutter/material.dart';
import 'package:linkup_pro/core/widgets/custom_text.dart';
import 'package:toastification/toastification.dart';

void showToast({
  ToastificationType type = ToastificationType.info,
  ToastificationStyle style = ToastificationStyle.simple,
  required String description,
  autoCloseDuration = const Duration(seconds: 5),
  borderRadius = 12,
  showProgressBar = true,
  closeOnClick = false,
  pauseOnHover = true,
  dragToClose = true,
  applyBlurEffect = true,
  animationDuration = const Duration(milliseconds: 300),
  TextDirection direction = TextDirection.ltr,
  alignment = Alignment.topRight,
  icon = const Icon(Icons.check),
  showIcon = false,
}) {
  toastification.show(
    type: type,
    style: style,
    description: CustomText(text: description),
    autoCloseDuration: autoCloseDuration,
    borderRadius: borderRadius,
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