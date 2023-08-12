import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
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
      backgroundColor: _seedColor,
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
    showUnselectedLabels: false,
    showSelectedLabels: false,
  );

  static final _outlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      side: BorderSide(
        color: _seedColor,
      ),
      minimumSize: const Size.fromHeight(42),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  );

  static const _seedColor = SalmonColors.blue;

  ThemeData light() {
    final colorScheme = ColorScheme.fromSeed(
      brightness: Brightness.light,
      seedColor: _seedColor,
    ).copyWith(primary: _seedColor);

    return ThemeData.light().copyWith(
      useMaterial3: true,

      //
      colorScheme: colorScheme,

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
      bottomNavigationBarTheme: _bottomNavBarTheme.copyWith(
        selectedIconTheme: IconThemeData(
          color: colorScheme.primary,
          size: 30,
        ),
      ),
    );
  }

  ThemeData dark() {
    final colorScheme = ColorScheme.fromSeed(
      brightness: Brightness.dark,
      seedColor: _seedColor,
    );

    return ThemeData.dark().copyWith(
      useMaterial3: true,

      //
      colorScheme: colorScheme,

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
      bottomNavigationBarTheme: _bottomNavBarTheme.copyWith(
        selectedIconTheme: IconThemeData(
          color: colorScheme.primary,
          size: 30,
        ),
      ),
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
        messageBackgroundColor: SalmonColors.lightBlue,
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

  static markdownStyleSheet(BuildContext context) =>
      MarkdownStyleSheet.fromTheme(context.theme).copyWith(
        h1: context.textTheme.headlineSmall
            ?.copyWith(fontWeight: FontWeight.bold),
        h2: context.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        h3: context.textTheme.titleMedium
            ?.copyWith(fontWeight: FontWeight.bold),
        h4: context.textTheme.titleSmall,
        h5: context.textTheme.bodyLarge,
        h6: context.textTheme.bodyMedium,
        h1Padding: const EdgeInsets.only(top: 24, bottom: 4),
        h2Padding: const EdgeInsets.only(top: 24, bottom: 4),
        h3Padding: const EdgeInsets.only(top: 24, bottom: 4),
        h4Padding: const EdgeInsets.only(top: 24, bottom: 4),
        h5Padding: const EdgeInsets.only(top: 24, bottom: 4),
        h6Padding: const EdgeInsets.only(top: 24, bottom: 4),
        p: context.textTheme.titleMedium
            ?.copyWith(color: SalmonColors.black.withOpacity(0.75)),
        blockquotePadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 24,
        ),
        blockquoteDecoration: BoxDecoration(
          color: SalmonColors.muted.withOpacity(0.15),
          borderRadius: BorderRadius.circular(8),
        ),
        pPadding: const EdgeInsets.symmetric(vertical: 8),
      );
}
