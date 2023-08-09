import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:salmon/helpers/salmon_extensions.dart';
import 'package:salmon/providers/l10n/async_l10n_provider.dart';
import 'package:salmon/theme/salmon_colors.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

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

  static final _dividerThemeData = DividerThemeData(
    thickness: 2,
    indent: 15,
    endIndent: 15,
    color: SalmonColors.muted,
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

      drawerTheme: DrawerThemeData(
        backgroundColor: SalmonColors.white,
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
        surfaceTintColor: Colors.transparent,
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

      drawerTheme: const DrawerThemeData(
        backgroundColor: SalmonColors.black,
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
        surfaceTintColor: Colors.transparent,
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

  StreamChatThemeData chatTheme(BuildContext context) {
    final isLight = context.theme.brightness == Brightness.light;

    return StreamChatThemeData.fromTheme(context.theme).copyWith(
      messageListViewTheme: StreamMessageListViewThemeData(
        backgroundColor: isLight ? SalmonColors.white : SalmonColors.black,
      ),
      messageInputTheme: StreamMessageInputThemeData(
        inputBackgroundColor: isLight ? SalmonColors.white : SalmonColors.black,
      ),
      ownMessageTheme: StreamMessageThemeData(
        messageBackgroundColor: SalmonColors.lightYellow,
        messageTextStyle: TextStyle(
          color: SalmonColors.white,
        ),
      ),
    );
  }

  /// returns light by default, unless changed by the user in the settings.
  static ThemeMode get themeMode {
    final themeMode = GetStorage().read<String>(SalmonConst.skThemeMode);
    switch (themeMode) {
      case SalmonConst.systemDefault:
        return ThemeMode.system;
      case SalmonConst.light:
        return ThemeMode.light;
      case SalmonConst.dark:
        return ThemeMode.dark;
      default:
        return ThemeMode.light;
    }
  }
}
