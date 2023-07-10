import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:salmon/helpers/salmon_const.dart';
import 'package:salmon/providers/l10n/async_l10n_provider.dart';
import 'package:salmon/providers/router/router_provider.dart';
import 'package:salmon/providers/theme/theme_data/theme_data_provider.dart';
import 'package:salmon/providers/theme/theme_mode/async_theme_mode_provider.dart';
import 'l10n/l10n_imports.dart';

class Salmon extends ConsumerWidget {
  const Salmon({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(asyncL10nProvider).when<Locale>(
          data: (locale) => locale,
          error: (_, __) => const Locale(SalmonConst.en),
          loading: () => const Locale(SalmonConst.en),
        );

    final themeMode = ref.watch(asyncThemeModeProvider).value;
    final theme = ref.watch(salmonThemeProvider);
    final router = ref.watch(routerProvider);

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
    );
  }
}
