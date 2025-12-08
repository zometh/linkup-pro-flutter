import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MyNavigator {
  final BuildContext context;

  MyNavigator(this.context);

  void navigateTo(Widget widget) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => widget));
  }

  void navigateToHomeAndClearStack() {
    context.go("");
  }
}



