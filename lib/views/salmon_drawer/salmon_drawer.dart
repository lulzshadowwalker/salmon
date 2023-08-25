part of 'components/salmon_drawer_components.dart';

class SalmonDrawer extends HookConsumerWidget {
  const SalmonDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isGuest = ref.read(a12nProvider).isGuest;
    final activePage = ref.watch(drawerPageProvider);

    return Drawer(
      child: SalmonSingleChildScrollView(
        child: Theme(
          data: Theme.of(context).copyWith(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Consumer(
                    builder: (context, ref, child) {
                      final user = ref.watch(currentUserProvider).value;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          IconButton(
                            onPressed: () {
                              Scaffold.of(context).closeDrawer();
                            },
                            icon: const FaIcon(
                              FontAwesomeIcons.xmark,
                              size: 42,
                            ),
                          ),
                          const SizedBox(height: 48),
                          SalmonCircleImageAvatar(
                            image: user?.pfp.asCachedNetImg,
                            radius: 128,
                          ),
                          const SizedBox(height: 24),
                          Padding(
                            padding:
                                const EdgeInsetsDirectional.only(start: 12),
                            child: Text(
                              isGuest
                                  ? SL.of(context).guest
                                  : (user?.displayName) ?? 'Unknown',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                          const Divider(height: 48),
                        ],
                      );
                    },
                  ),
                  const Spacer(),
                  _DrawerTile(
                    onTap: () {
                      ref.read(drawerPageProvider.notifier).set(const Home());
                      Navigator.of(context).pop();
                    },
                    leading: AnimatedHomeIcon(
                      size: 48,
                      isActive: activePage.runtimeType == Home,
                      inactiveColor: context.theme.textTheme.bodyLarge?.color,
                    ),
                    title: SL.of(context).home,
                    isActive: activePage.runtimeType == Home,
                  ),
                  _DrawerTile(
                    onTap: () {
                      ref.read(drawerPageProvider.notifier).set(const Events());
                      Navigator.of(context).pop();
                    },
                    leading: AnimatedEventsIcon(
                      isActive: activePage.runtimeType == Events,
                      inactiveColor: context.theme.textTheme.bodyLarge?.color,
                    ),
                    title: 'Events', // TODO tr
                    isActive: activePage.runtimeType == Events,
                  ),
                  _DrawerTile(
                    onTap: () {
                      ref.read(drawerPageProvider.notifier).set(const Events());
                      Navigator.of(context).pop();
                    },
                    leading: AnimatedAnalyticsIcon(
                      isActive: activePage.runtimeType == Analytics,
                      inactiveColor: context.theme.textTheme.bodyLarge?.color,
                    ),
                    title: SL.of(context).analytics,
                    isActive: activePage.runtimeType == Analytics,
                  ),
                  _DrawerTile(
                    onTap: () {
                      ref
                          .read(drawerPageProvider.notifier)
                          .set(const Settings());
                      Navigator.of(context).pop();
                    },
                    leading: AnimatedSettingsIcon(
                      isActive: activePage.runtimeType == Settings,
                      inactiveColor: context.theme.textTheme.bodyLarge?.color,
                    ),
                    title: SL.of(context).settings,
                    isActive: activePage.runtimeType == Settings,
                  ),
                  const Spacer(flex: 6),
                  const _SignOutTile(),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
