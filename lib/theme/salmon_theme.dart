import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:salmon/providers/l10n/async_l10n_provider.dart';
import 'package:salmon/theme/salmon_colors.dart';

import '../helpers/salmon_const.dart';

final class SalmonTheme {
  static final String? enFontFamily = GoogleFonts.aBeeZee().fontFamily;
  static final String? arFontFamily = GoogleFonts.elMessiri().fontFamily;

  static String? _fontFamily(BuildContext context) =>
      ProviderContainer().read(asyncL10nProvider).value?.languageCode ==
              SalmonConst.en
          ? enFontFamily
          : enFontFamily;

  static const _dividerThemeData = DividerThemeData(
    thickness: 2,
    indent: 15,
    endIndent: 15,
  );

  static final _elevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: SalmonColors.blue,
      foregroundColor: SalmonColors.white,
      minimumSize: const Size.fromHeight(42),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  );

  static final _outlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      side: const BorderSide(
        color: SalmonColors.blue,
      ),
      foregroundColor: SalmonColors.blue,
      minimumSize: const Size.fromHeight(42),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  );

  static const _seedColor = SalmonColors.blue;

  static ThemeData light(BuildContext context) {
    return ThemeData.light().copyWith(
      useMaterial3: true,

      //
      colorScheme: ColorScheme.fromSeed(
        brightness: Brightness.light,
        seedColor: _seedColor,
      ),

      //
      textTheme: ThemeData.light().textTheme.apply(
            fontFamily: _fontFamily(context),
            bodyColor: SalmonColors.black,
            displayColor: SalmonColors.black,
            decorationColor: SalmonColors.black,
          ),

      //
      scaffoldBackgroundColor: SalmonColors.white,

      //
      dividerTheme: _dividerThemeData,

      //
      elevatedButtonTheme: _elevatedButtonTheme,

      //
      outlinedButtonTheme: _outlinedButtonTheme,
    );
  }
}
