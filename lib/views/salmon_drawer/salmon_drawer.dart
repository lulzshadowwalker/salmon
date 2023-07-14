part of 'components/salmon_drawer_components.dart';

class SalmonDrawer extends HookConsumerWidget {
  const SalmonDrawer({
    required this.page,
    super.key,
  });

  final Widget page;

  double _maybeNegate(double value, BuildContext context) =>
      Directionality.of(context) == TextDirection.ltr ? value : value * -1;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOpen = ref.watch(drawerStateProvider) == DrawerStatus.open;

    final con =
        useAnimationController(duration: const Duration(milliseconds: 220));

    final rotationAnim = Tween<double>(
      begin: 0,
      end: _maybeNegate(0.08, context),
    ).animate(
      CurvedAnimation(
        curve: Curves.easeInBack,
        parent: con,
      ),
    );

    final xOffsetAnim = Tween<double>(
      begin: 0,
      end: _maybeNegate(240, context),
    ).animate(con);

    final yOffsetAnim = Tween<double>(
      begin: 0,
      end: 50,
    ).animate(con);

    final scaleAnim = Tween<double>(
      begin: 1,
      end: 0.85,
    ).animate(con);

    final scale = useAnimation(scaleAnim);
    final xOffset = useAnimation(xOffsetAnim);
    final yOffset = useAnimation(yOffsetAnim);
    final rotation = useAnimation(rotationAnim);

    useEffect(() {
      isOpen ? con.forward() : con.reverse();

      return null;
    }, [isOpen]);

    // TODO check directionality with locale

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 211, 182, 120),
      body: Stack(
        alignment: Alignment.center,
        children: [
          if (isOpen) const _DrawerComponents(),
          Transform(
            alignment: Directionality.of(context) == TextDirection.ltr
                ? Alignment.bottomLeft
                : Alignment.bottomLeft,
            transform: Matrix4.identity()
              ..scale(scale)
              // TODO dynamic drawer [Transform.translate]
              ..translate(xOffset, yOffset)
              ..rotateZ(rotation),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              curve: Curves.easeOutCubic,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(isOpen ? 35 : 0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 12,
                    blurRadius: 50,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: page,
            ),
          ),
        ],
      ),
    );
  }
}
