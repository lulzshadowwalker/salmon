import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'async_theme_mode_provider.g.dart';

@Riverpod(keepAlive: true)
class AsyncThemeMode extends _$AsyncThemeMode {
  static const _storageKey = 'theme_mode';
  static const light = 'light';
  static const dark = 'dark';
  static const systemDefault = 'system_default';

  @override
  Future<ThemeMode> build() async {
    final storage = GetStorage();
    final themeMode = storage.read<String>(_storageKey);

    switch (themeMode) {
      case dark:
        return ThemeMode.dark;
      case light:
        return ThemeMode.light;

      default:
        storage.write(_storageKey, light);
        return ThemeMode.light;
    }
  }

  Future<void> toggle() async {
    state = const AsyncValue.loading();

    final storage = GetStorage();

    state = await AsyncValue.guard(() async {
      if (state.value == ThemeMode.light) {
        storage.write(_storageKey, dark);
        return ThemeMode.dark;
      } else {
        storage.write(_storageKey, light);
        return ThemeMode.light;
      }
    });
  }
}
