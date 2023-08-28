part of './settings_comps.dart';

class _AppSettings extends HookConsumerWidget {
  const _AppSettings();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(asyncL10nProvider).asData?.value ??
        const Locale(SalmonConst.en);

    final supportedLocales = ref.watch(supportedLocalesProvider);

    final isGuest = ref.watch(a12nProvider).isGuest;

    return _SettingsSection(
      title: SL.of(context).applicationSettings,
      options: [
        if (!isGuest)
          _SettingsOption(
            title: Text(context.sl.notifications.toLowerCase()),
            onTap: () => context.pushNamed(SalmonRoutes.notifsDetails),
            margin: const EdgeInsets.only(bottom: 8),
          ),
        _SettingsOption(
          title: Text(SL.of(context).language),
          trailing: DropdownButton(
            value: locale.languageCode,
            borderRadius: BorderRadius.circular(10),
            underline: const SizedBox.shrink(),
            elevation: 4,
            items: List.generate(
              supportedLocales.length,
              (index) {
                final langCode = supportedLocales[index].languageCode;

                return DropdownMenuItem(
                  value: langCode,
                  child: Center(
                    child: SizedBox(
                      height: 25,
                      width: 35,
                      child: CountryFlag(
                        country: langCode == SalmonConst.ar
                            ? Country.jo
                            : Country.gb,
                      ),
                    ),
                  ),
                );
              },
            ),
            onChanged: (val) {
              switch (val) {
                case SalmonConst.ar:
                  ref.read(asyncL10nProvider.notifier).ar();
                  break;
                case SalmonConst.en:
                default:
                  ref.read(asyncL10nProvider.notifier).en();
              }
            },
          ),
        ),
        _SettingsOption(
          title: Text(SL.of(context).darkMode),
          trailing: const Padding(
            padding: EdgeInsetsDirectional.only(end: 12),
            child: _DarkModeSwitch(),
          ),
        ),
      ],
    );
  }
}
