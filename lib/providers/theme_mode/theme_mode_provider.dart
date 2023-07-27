import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:salmon/helpers/salmon_const.dart';

import '../../theme/salmon_theme.dart';

final themeModeProvider = StateNotifierProvider<ThemeModeController, ThemeMode>(
    (ref) => ThemeModeController(SalmonTheme.themeMode));

class ThemeModeController extends StateNotifier<ThemeMode> {
  ThemeModeController(ThemeMode mode) : super(mode);

  Future<void> mode(ThemeMode mode) async {
    state = mode;

    await GetStorage().write(SalmonConst.skThemeMode, mode.name);
  }
}
