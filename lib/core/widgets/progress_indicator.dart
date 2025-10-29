  import 'package:flutter/material.dart';


Widget customProgressIndicator({Color? color, double? size}) {
  return SizedBox(
    width: size ?? 24,
    height: size ?? 24,
    child: Center(
      child: CircularProgressIndicator.adaptive(
        strokeWidth: 2.5,
        valueColor: AlwaysStoppedAnimation<Color>(
            color ?? Colors.blueAccent),
      ),
    ),
  );
}