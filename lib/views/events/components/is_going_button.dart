part of 'event_components.dart';

class _IsGoingButton extends StatefulHookConsumerWidget {
  const _IsGoingButton();

  @override
  ConsumerState<_IsGoingButton> createState() => _IsGoingButtonState();
}

class _IsGoingButtonState extends ConsumerState<_IsGoingButton> {
  static const _timeout = Duration(milliseconds: 1500);
  Timer? _debounce;

  @override
  Widget build(BuildContext context) {
    final event = _EventData.of(context)?.data;
    final isGuest = ref.watch(a12nProvider).isGuest;

    return event == null || isGuest
        ? const SizedBox.shrink()
        : Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 12,
            ),
            child: Consumer(
              builder: (context, ref, child) {
                final isGoing = ref.watch(_isGoingProvider(event));

                return OutlinedButton(
                  style: context.theme.outlinedButtonTheme.style?.copyWith(
                    backgroundColor: MaterialStateProperty.resolveWith((_) =>
                        HSLColor.fromColor(context.cs.primary)
                            .withLightness(0.65)
                            .toColor()
                            .withOpacity(0.2)),
                  ),
                  onPressed: () {
                    ref.read(_isGoingProvider(event).notifier).state = !isGoing;

                    if (_debounce?.isActive ?? false) _debounce?.cancel();
                    _debounce = Timer(_timeout, () async {
                      ref.read(_isGoingProvider(event))
                          ? await ref
                              .read(eventsControllerProvider)
                              .interested(event)
                          : await ref
                              .read(eventsControllerProvider)
                              .uninterested(event);

                      ref.invalidate(eventUsersProvider(event));
                    });
                  },
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 450),
                    child: isGoing
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Padding(
                                padding: EdgeInsetsDirectional.only(end: 8),
                                child: FaIcon(
                                  FontAwesomeIcons.check,
                                  color: SalmonColors.white,
                                ),
                              ),
                              Text(
                                context.sl.going,
                                style: const TextStyle(
                                  color: SalmonColors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          )
                        : Text(
                            context.sl.interested,
                            style: const TextStyle(
                              color: SalmonColors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                );
              },
            ),
          );
  }
}
