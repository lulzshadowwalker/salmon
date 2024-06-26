part of './salmon_poll_components.dart';

class _SalmonPollOption extends StatefulHookConsumerWidget {
  const _SalmonPollOption({
    required this.option,
  });

  final PollOption option;

  static const _duration = Duration(milliseconds: 250);
  static const _height = 38.0;
  static const _borderRadius = 8.0;

  @override
  ConsumerState<_SalmonPollOption> createState() => _SalmonPollOptionState();
}

class _SalmonPollOptionState extends ConsumerState<_SalmonPollOption> {
  static const _timeout = Duration(milliseconds: 0);
  Timer? _debounce;

  @override
  Widget build(BuildContext context) {
    final poll = PollData.of(context)!.data;
    final so = ref.watch(_selectedOptProvider(poll));

    final interactionPercentage = ref.watch(
      pollOptVotePercentageProvider(poll.id ?? '', widget.option.id ?? ''),
    );

    final fillController =
        useAnimationController(duration: _SalmonPollOption._duration * 2);
    final fillWidthFactor = useAnimation(
      Tween<double>(
        begin: 0,
        end: interactionPercentage.normalized(maxVal: 100),
      ).animate(
        CurvedAnimation(
          parent: fillController,
          curve: Curves.easeOutQuad,
          reverseCurve: Curves.linear,
        ),
      ),
    );

    final isActive = ref.watch(_isActiveProvider(poll));

    useEffect(() {
      isActive ? fillController.forward() : fillController.reverse();
      return null;
    }, [isActive, so]);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(_SalmonPollOption._borderRadius),
        border: Border.all(
          color: SalmonColors.muted,
          width: 0.5,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          FractionallySizedBox(
            widthFactor: fillWidthFactor,
            child: ClipRRect(
              borderRadius: const BorderRadiusDirectional.horizontal(
                start: Radius.circular(_SalmonPollOption._borderRadius),
              ),
              child: Container(
                color: context.cs.primaryContainer,
                height: _SalmonPollOption._height,
              ),
            ),
          ),
          InkWell(
            onTap: () async {
              ref.read(_selectedOptProvider(poll).notifier).state =
                  widget.option.id;
              ref.read(_isActiveProvider(poll).notifier).state = true;

              if (_debounce?.isActive ?? false) _debounce?.cancel();
              _debounce = Timer(_timeout, () {
                ref
                    .read(pollsControllerProvider)
                    .vote(poll: poll, optionId: widget.option.id ?? '');
              });
            },
            child: Container(
              height: _SalmonPollOption._height,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: AnimatedAlign(
                      duration: _SalmonPollOption._duration,
                      curve: Curves.easeOutCubic,
                      alignment: !isActive
                          ? AlignmentDirectional.center
                          : AlignmentDirectional.centerStart,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // TODO set overflow and alignment
                          Flexible(
                            child: Text(
                              (context.isEn
                                      ? widget.option.enTitle
                                      : widget.option.arTitle) ??
                                  context.sl.unknown,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          AnimatedSwitcher(
                            duration: _SalmonPollOption._duration,
                            child: so == widget.option.id && isActive
                                ? Padding(
                                    padding: const EdgeInsetsDirectional.only(
                                      start: 8,
                                    ),
                                    child: Icon(
                                      Icons.check_circle,
                                      color: SalmonColors.green,
                                    ),
                                  )
                                : const SizedBox.shrink(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  AnimatedSwitcher(
                    duration: _SalmonPollOption._duration,
                    child: isActive
                        ? Directionality(
                            textDirection: TextDirection.ltr,
                            child: AnimatedFlipCounter(
                              value: interactionPercentage.round(),
                              curve: Curves.easeOutQuad,
                              duration: const Duration(milliseconds: 550),
                              suffix: ' %',
                            ),
                          )
                        : const SizedBox.shrink(),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

final _isActiveProvider =
    StateProvider.autoDispose.family<bool, Poll>((ref, poll) {
  return ref.watch(_selectedOptProvider(poll)) != null;
});

final _selectedOptProvider =
    StateProvider.family.autoDispose<String?, Poll>((ref, poll) {
  return ref.watch(checkVoteProvider(poll)).value?.optionId;
});
