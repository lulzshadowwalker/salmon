part of './settings_comps.dart';

class _DarkModeSwitch extends HookConsumerWidget {
  const _DarkModeSwitch();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = !ref.watch(isLightThemeProvider);

    return Switch(
      value: isDark,
      onChanged: (_) {
        ref.read(asyncThemeModeProvider.notifier).toggle();
      },
    );
  }
}
