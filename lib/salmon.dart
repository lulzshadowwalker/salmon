import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:salmon/helpers/salmon_const.dart';
import 'package:salmon/helpers/salmon_extensions.dart';
import 'package:salmon/providers/chat/chat_provider.dart';
import 'package:salmon/providers/l10n/async_l10n_provider.dart';
import 'package:salmon/providers/router/router_provider.dart';
import 'package:salmon/providers/theme_data/theme_data_provider.dart';
import 'package:salmon/providers/theme_mode/async_theme_mode_provider.dart';
import 'package:salmon/theme/salmon_colors.dart';
import 'package:salmon/theme/salmon_theme.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'l10n/l10n_imports.dart';

class Salmon extends ConsumerStatefulWidget {
  const Salmon({super.key});

  @override
  ConsumerState<Salmon> createState() => _SalmonState();
}

class _SalmonState extends ConsumerState<Salmon> {
  @override
  Widget build(BuildContext context) {
    final locale = ref.watch(asyncL10nProvider).when<Locale>(
          data: (locale) => locale,
          error: (_, __) => const Locale(SalmonConst.en),
          loading: () => const Locale(SalmonConst.en),
        );

    final themeMode = ref.watch(asyncThemeModeProvider).value;
    final theme = ref.watch(salmonThemeProvider);
    final router = ref.watch(routerProvider);
    final client = ref.watch(chatClientProvider);

    return MaterialApp.router(
      title: 'Salmon',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: SL.localizationsDelegates,
      supportedLocales: SL.supportedLocales,
      locale: locale,
      themeMode: themeMode,
      theme: theme.light(),
      darkTheme: theme.dark(),
      routerConfig: router.config,
      builder: (context, child) => StreamChat(
        client: client,
        streamChatThemeData: theme.chatTheme(context),
        child: child,
      ),
    );
  }
}
