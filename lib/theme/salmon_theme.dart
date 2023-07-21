import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:salmon/providers/l10n/async_l10n_provider.dart';
import 'package:salmon/theme/salmon_colors.dart';

import '../helpers/salmon_const.dart';

final class SalmonTheme {
  SalmonTheme(this.ref);
  final Ref ref;

  static final String? enFontFamily = GoogleFonts.aBeeZee().fontFamily;
  static final String? arFontFamily = GoogleFonts.elMessiri().fontFamily;

  String? get _fontFamily =>
      ref.read(asyncL10nProvider).value?.languageCode == SalmonConst.en
          ? enFontFamily
          : enFontFamily;

  static const _dividerThemeData = DividerThemeData(
    thickness: 2,
    indent: 15,
    endIndent: 15,
  );

  static final _elevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: SalmonColors.yellow,
      foregroundColor: SalmonColors.white,
      minimumSize: const Size.fromHeight(42),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  );

  static final _bottomNavBarTheme = BottomNavigationBarThemeData(
    backgroundColor: Colors.transparent,
    elevation: 0,
    unselectedIconTheme: IconThemeData(
      color: SalmonColors.mutedLight,
      size: 30,
    ),
    selectedIconTheme: IconThemeData(
      color: SalmonColors.yellow,
      size: 30,
    ),
    showUnselectedLabels: false,
    showSelectedLabels: false,
  );

  static final _outlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      side: BorderSide(
        color: SalmonColors.yellow,
      ),
      foregroundColor: SalmonColors.yellow,
      minimumSize: const Size.fromHeight(42),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  );

  static final _seedColor = SalmonColors.yellow;

  ThemeData light() {
    return ThemeData.light().copyWith(
      useMaterial3: true,

      //
      colorScheme: ColorScheme.fromSeed(
        brightness: Brightness.light,
        seedColor: _seedColor,
      ),

      //
      iconTheme: const IconThemeData(
        color: SalmonColors.black,
      ),

      //
      textTheme: ThemeData.light().textTheme.apply(
            fontFamily: _fontFamily,
            bodyColor: SalmonColors.black,
            displayColor: SalmonColors.black,
            decorationColor: SalmonColors.black,
          ),

      //
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: SalmonColors.black,
        elevation: 0,
        centerTitle: true,
      ),

      //
      scaffoldBackgroundColor: SalmonColors.white,

      //
      dividerTheme: _dividerThemeData,

      //
      elevatedButtonTheme: _elevatedButtonTheme,

      //
      outlinedButtonTheme: _outlinedButtonTheme,

      //
      bottomNavigationBarTheme: _bottomNavBarTheme,
    );
  }

  ThemeData dark() {
    return ThemeData.dark().copyWith(
      useMaterial3: true,

      //
      colorScheme: ColorScheme.fromSeed(
        brightness: Brightness.dark,
        seedColor: _seedColor,
      ),

      //
      iconTheme: IconThemeData(
        color: SalmonColors.white,
      ),

      //
      textTheme: ThemeData.dark().textTheme.apply(
            fontFamily: _fontFamily,
            bodyColor: SalmonColors.white,
            displayColor: SalmonColors.white,
            decorationColor: SalmonColors.white,
          ),

      //
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: SalmonColors.white,
        elevation: 0,
        centerTitle: true,
      ),

      //
      scaffoldBackgroundColor: SalmonColors.black,

      //
      dividerTheme: _dividerThemeData,

      //
      elevatedButtonTheme: _elevatedButtonTheme,

      //
      outlinedButtonTheme: _outlinedButtonTheme,

      //
      bottomNavigationBarTheme: _bottomNavBarTheme,
    );
  }
}
