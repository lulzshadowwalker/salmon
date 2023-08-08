part of './comps/settings_comps.dart';

class Settings extends ConsumerWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isGuest = ref.watch(a12nProvider).isGuest;

    return Scaffold(
      backgroundColor: SalmonColors.yellow,
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsetsDirectional.only(start: 24),
          child: AnimatedMenuIcon(),
        ),
        title: Text(SL.of(context).settings),
      ),
      body: SalmonSingleChildScrollView(
        child: SalmonPageWrapper(
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
                      NotifController.showInDevPopup(context);
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
