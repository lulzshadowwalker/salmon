import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:salmon/providers/l10n/l10n_provider.dart';
import 'l10n/l10n_imports.dart';

class Salmon extends ConsumerWidget {
  const Salmon({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(asyncL10nProvider).when<Locale>(
          data: (locale) => locale,
          error: (_, __) => const Locale('en'),
          loading: () => const Locale('en'),
        );

    return MaterialApp(
      title: 'Salmon',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: SalmonLocalizations.localizationsDelegates,
      supportedLocales: SalmonLocalizations.supportedLocales,
      locale: locale,
      home: Builder(
        builder: (context) {
          return Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () {
                  SalmonLocalizations.of(context).localeName == 'en'
                      ? ref.read(asyncL10nProvider.notifier).ar()
                      : ref.read(asyncL10nProvider.notifier).en();
                },
                child: Text(SalmonLocalizations.of(context).helloWorld),
              ),
            ),
          );
        },
      ),
    );
  }
}
