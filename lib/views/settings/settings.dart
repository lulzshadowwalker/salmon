part of './comps/settings_comps.dart';

class Settings extends ConsumerWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: SalmonColors.yellow,
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsetsDirectional.only(start: 24),
          child: AnimatedMenuIcon(),
        ),
        title: Text(SL.of(context).settings),
      ),
      body: const SalmonSingleChildScrollView(
        child: SalmonPageWrapper(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SettingsProfileHeader(),
              SizedBox(height: 32),
              _AccountSettings(),
              _AppSettings(),
            ],
          ),
        ),
      ),
    );
  }
}
