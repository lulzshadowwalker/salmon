part of './salmon_drawer_components.dart';

class _DrawerComponents extends HookConsumerWidget {
  const _DrawerComponents();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isGuest = ref.read(a12nProvider).isGuest;

    final activePage = ref.watch(drawerPageProvider);

    final textStyle = Theme.of(context).textTheme.titleSmall?.copyWith(
          color: SalmonColors.white,
          fontWeight: FontWeight.bold,
        );

    return SalmonSingleChildScrollView(
      child: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              Consumer(
                builder: (context, ref, child) {
                  final user = ref.watch(salmonUserProvider).value;

                  return Row(
                    children: [
                      SalmonCircleImageAvatar(
                        image: user?.pfp.asCachedNetImg,
                        radius: 80,
                      ),
                      const SizedBox(width: 16),
                      Text(
                        isGuest
                            ? SL.of(context).guest
                            : (user?.displayName).maybeAsEmpty,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(color: SalmonColors.white),
                      )
                    ],
                  );
                },
              ),
              const SizedBox(height: 48),
              Bounceable(
                onTap: () {
                  ref.read(drawerPageProvider.notifier).set(const Home());
                },
                child: ListTile(
                  enableFeedback: true,
                  leading: AnimatedHomeIcon(
                    size: 48,
                    isActive: activePage.runtimeType == Home,
                    inactiveColor: SalmonColors.white,
                  ),
                  title: Text(
                    SL.of(context).home,
                    style: textStyle,
                  ),
                ),
              ),
              Bounceable(
                onTap: () {
                  ref.read(drawerPageProvider.notifier).set(const Analytics());
                },
                child: ListTile(
                  enableFeedback: true,
                  leading: AnimatedAnalyticsIcon(
                    isActive: activePage.runtimeType == Analytics,
                    inactiveColor: SalmonColors.white,
                  ),
                  title: Text(
                    SL.of(context).analytics,
                    style: textStyle,
                  ),
                ),
              ),

              // TODO refactor drawer content tiles out into sep components
              Bounceable(
                onTap: () {
                  ref.read(drawerPageProvider.notifier).set(const Settings());
                },
                child: ListTile(
                  enableFeedback: true,
                  leading: AnimatedSettingsIcon(
                    isActive: activePage.runtimeType == Settings,
                    inactiveColor: SalmonColors.white,
                  ),
                  title: Text(
                    SL.of(context).settings,
                    style: textStyle,
                  ),
                ),
              ),
              const Spacer(),
              const _SignOutTile(),
              const SizedBox(height: 48)
            ],
          ),
        ),
      ),
    );
  }
}
