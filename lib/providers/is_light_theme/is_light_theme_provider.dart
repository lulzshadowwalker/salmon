import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:salmon/providers/theme_mode/theme_mode_provider.dart';

final isLightThemeProvider = Provider<bool>((ref) {
  return ref.watch(themeModeProvider) == ThemeMode.light;
});
