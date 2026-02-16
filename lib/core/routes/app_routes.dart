import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MyNavigator {
  final BuildContext context;

  MyNavigator(this.context);

  /// Navigue vers [path]. Par défaut cela fait un `push` (empile la route).
  /// Si [replace] est true, utilise `go` (remplace la stack actuelle).
  void navigateTo(String path, {bool replace = false}) {
    if (replace) {
      GoRouter.of(context).go(path);
    } else {
      GoRouter.of(context).push(path);
    }
  }

  /// Navigue vers une route nommée (avec paramètres optionnels).
  void navigateToNamed(String name, {Map<String, String>? params, Object? extra, bool replace = false}) {
    final paramsMap = params ?? <String, String>{};
    final location = GoRouter.of(context).namedLocation(name, queryParameters: paramsMap);
    if (replace) {
      GoRouter.of(context).go(location, extra: extra);
    } else {
      GoRouter.of(context).push(location, extra: extra);
    }
  }

  /// Retourne à l'écran précédent en utilisant go_router.
  void pop() {
    GoRouter.of(context).pop();
  }

  /// Navigue vers l'écran d'accueil et remplace la stack.
  void navigateToHomeAndClearStack() {
    GoRouter.of(context).go('/home');
  }
}
