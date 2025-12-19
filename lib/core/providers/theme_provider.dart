import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:get_it/get_it.dart';
import 'package:linkup_pro/core/services/localdb/localdb.dart';

part 'theme_provider.g.dart';

enum AppThemeMode { light, dark, system }

@Riverpod(keepAlive: true)
class ThemeNotifier extends _$ThemeNotifier {
  final _localDb = GetIt.I<LocalDBService>();

  @override
  AppThemeMode build() {
    _loadThemeMode();
    return AppThemeMode.system;
  }

  Future<void> _loadThemeMode() async {
    final savedTheme = await _localDb.getThemeMode();
    if (savedTheme != null) {
      state = AppThemeMode.values.firstWhere(
        (e) => e.name == savedTheme,
        orElse: () => AppThemeMode.system,
      );
    }
  }

  Future<void> setThemeMode(AppThemeMode mode) async {
    state = mode;
    await _localDb.saveThemeMode(mode.name);
  }

  ThemeMode get themeMode {
    switch (state) {
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
      case AppThemeMode.system:
        return ThemeMode.system;
    }
  }
}

