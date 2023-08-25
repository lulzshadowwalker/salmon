part of './comps/settings_comps.dart';

class Settings extends ConsumerWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isGuest = ref.watch(a12nProvider).isGuest;

    return Scaffold(
      appBar: AppBar(
        leading: const MenuButton(),
        title: Text(SL.of(context).settings),
        bottom: const AppBarDivider(),
      ),
      drawer: const SalmonDrawer(),
      body: SalmonSingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _SettingsProfileHeader(),
              const SizedBox(height: 32),
              if (!isGuest) const _AccountSettings(),
              const _AppSettings(),
              _SettingsSection(
                title: 'About',
                options: [
                  _SettingsOption(
                    title: const Text('about us'),
                    onTap: () {
                      NotifsController.showInDevPopup(context);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
