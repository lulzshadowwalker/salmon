part of 'event_components.dart';

class _IsGoingButton extends StatefulWidget {
  const _IsGoingButton();

  @override
  State<_IsGoingButton> createState() => _IsGoingButtonState();
}

class _IsGoingButtonState extends State<_IsGoingButton> {
  static const _timeout = Duration(milliseconds: 1500);
  Timer? _debounce;

  @override
  Widget build(BuildContext context) {
    final event = _EventData.of(context)!.data;

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 12,
      ),
      child: Consumer(
        builder: (context, ref, child) {
          final isGoing = ref.watch(_isGoingProvider(event));

          return OutlinedButton(
            style: context.theme.outlinedButtonTheme.style?.copyWith(
              backgroundColor: MaterialStateProperty.resolveWith(
                (_) => context.cs.primary.withOpacity(0.2),
              ),
            ),
            onPressed: () {
              ref.read(_isGoingProvider(event).notifier).state = !isGoing;

              if (_debounce?.isActive ?? false) _debounce?.cancel();
              _debounce = Timer(_timeout, () async {
                ref.read(_isGoingProvider(event))
                    ? await ref.read(eventsControllerProvider).interested(event)
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
                          child: FaIcon(FontAwesomeIcons.check),
                        ),
                        Text(context.sl.going),
                      ],
                    )
                  : Text('${context.sl.interested}?'),
            ),
          );
        },
      ),
    );
  }
}
