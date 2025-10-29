import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:get_it/get_it.dart';
import 'package:linkup_pro/core/services/localdb/localdb.dart';

class AuthProvider extends ChangeNotifier {
  final LocalDBService _localDBService = GetIt.I<LocalDBService>();
  bool _isLoggedIn = false;

  AuthProvider() {
    _checkLoginStatus();
  }

  bool get isLoggedIn => _isLoggedIn;

  Future<void> _checkLoginStatus() async {
    final token = await _localDBService.getToken();
    _isLoggedIn = token != null;
    notifyListeners();
  }

  Future<void> login() async {
    _isLoggedIn = true;
    notifyListeners();
  }

  Future<void> logout() async {
    await _localDBService.clearAllData();
    _isLoggedIn = false;
    notifyListeners();
  }
}

final authProvider = ChangeNotifierProvider((ref) => AuthProvider());
