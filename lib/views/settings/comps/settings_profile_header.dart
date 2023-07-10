part of './settings_comps.dart';

class _SettingsProfileHeader extends ConsumerWidget {
  const _SettingsProfileHeader();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(salmonUserProvider).value;
    final isGuest = ref.read(a12nProvider).isGuest;

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [
            SalmonCircleImageAvatar(
              image: user?.pfp.asCachedNetImg,
              radius: 80,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user?.displayName ?? SL.of(context).guest,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  isGuest
                      ? GestureDetector(
                          onTap: () {
                            if (isGuest) {
                              ref.read(a12nProvider).signOut(context);
                              return;
                            }
                          },
                          child: Text(
                            SL.of(context).createAnAccount,
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      color: SalmonColors.muted,
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                        )
                      : Text(
                          (user?.email).maybeAsEmpty,
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge
                              ?.copyWith(color: SalmonColors.muted),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
