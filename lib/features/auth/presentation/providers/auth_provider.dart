import 'package:flutter/cupertino.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_provider.g.dart';

@riverpod
class Auth extends _$Auth {
  late final TextEditingController emailController;
  late final TextEditingController passwordController;

  @override
  void build() {
    emailController = TextEditingController();
    passwordController = TextEditingController();

    ref.onDispose(() {
      emailController.dispose();
      passwordController.dispose();
    });
  }
}
