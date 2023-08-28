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
          onTap: () => context.pushNamed(SalmonRoutes.accountDetails),
        )
      ],
    );
  }
}
