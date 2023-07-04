import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:salmon/helpers/salmon_const.dart';
import 'package:salmon/providers/l10n/async_l10n_provider.dart';
import 'package:salmon/router/salmon_router.dart';
import 'package:salmon/theme/salmon_theme.dart';
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

    return MaterialApp.router(
      title: 'Salmon',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: SalmonLocalizations.localizationsDelegates,
      supportedLocales: SalmonLocalizations.supportedLocales,
      locale: locale,
      theme: SalmonTheme.light(context),
      routerConfig: SalmonRouter.config,
    );
  }
}
