// ignore_for_file: use_build_context_synchronously

part of './settings_comps.dart';

class _AccountSettings extends HookConsumerWidget {
  const _AccountSettings();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _SettingsSection(
      title: SL.of(context).accountSettings,
      options: [
        _SettingsOption(
          title: Text(SL.of(context).accountDetails),
          trailing: Icon(
            Directionality.of(context) == TextDirection.ltr
                ? FontAwesomeIcons.angleRight
                : FontAwesomeIcons.angleLeft,
            size: 18,
          ),
          onTap: () => context.pushNamed(SalmonRoutes.accountDetails),
        )
      ],
    );
  }
}
