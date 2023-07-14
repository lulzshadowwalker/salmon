part of './salmon_drawer_components.dart';

class _SignOutTile extends HookConsumerWidget {
  const _SignOutTile();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isGuest = ref.watch(a12nProvider).isGuest;

    final con = useAnimationController(
      lowerBound: 5.normalized(maxVal: 27),
      initialValue: 1.0,
      duration: const Duration(),
    );

    final wantsToSignOut = useState(false);
    final isLoaded = useState(false);
    final initSignOut = useState(false);
    final isMounted = useIsMounted();

    useEffect(() {
      if (isGuest && wantsToSignOut.value) {
        initSignOut.value = true;

        ref
            .read(a12nProvider)
            .signOut(context)
            .then((_) => wantsToSignOut.value = false);
      } else if (wantsToSignOut.value && !isGuest) {
        con.animateBack(con.lowerBound).then(
          (_) {
            Future.delayed(const Duration(milliseconds: 100), () async {
              initSignOut.value = true;
              await ref.read(a12nProvider).signOut(context);

              if (isMounted()) wantsToSignOut.value = false;
            });
          },
        );
      } else {
        con.animateTo(1);
        initSignOut.value = false;
      }

      return null;
    }, [
      isLoaded.value,
      wantsToSignOut.value,
    ]);

    return GestureDetector(
      onTap: () {
        wantsToSignOut.value = true;
      },
      child: Row(
        children: [
          if (isGuest) const SizedBox(width: 18),
          if (!isGuest) ...[
            AnimatedContainer(
              duration: con.duration!,
              curve: Curves.easeOutCubic,
              width: wantsToSignOut.value ? 0 : 18,
            ),
            Transform.flip(
              flipX: true,
              child: ColorFiltered(
                colorFilter: const ColorFilter.mode(
                  SalmonColors.black,
                  BlendMode.srcIn,
                ),
                child: Lottie.asset(
                  SalmonAnims.signOut,
                  height: 40,
                  controller: con,
                  onLoaded: (comp) {
                    con.duration = comp.duration * 0.4;
                    isLoaded.value = true;
                  },
                  addRepaintBoundary: true,
                ),
              ),
            ),
          ],
          const SizedBox(width: 8),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 350),
            child: initSignOut.value
                ? const SalmonLoadingIndicator(
                    color: SalmonColors.black,
                  )
                : Text(
                    isGuest
                        ? SL.of(context).createAnAccount
                        : SL.of(context).signOut,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: SalmonColors.black,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
          )
        ],
      ),
    );
  }
}
