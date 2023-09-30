part of './settings_comps.dart';

class _NotifSwitch extends StatefulHookConsumerWidget {
  const _NotifSwitch({
    required this.agency,
  });

  final Agency agency;

  @override
  ConsumerState<_NotifSwitch> createState() => _NotifSwitchState();
}

class _NotifSwitchState extends ConsumerState<_NotifSwitch> {
  static const _timeout = Duration(milliseconds: 500);
  Timer? _debounce;

  @override
  Widget build(BuildContext context) {
    final isSubbed = useState<bool>(false);
    final topic = useMemoized(
      () => NotifsController.generateTopicName(widget.agency.enName ?? ''),
    );

    ref.listen(
      checkTopicSubscriptionProvider(topic),
      (previous, next) {
        isSubbed.value = next.value ?? false;
      },
    );

    return WillPopScope(
      onWillPop: () async {
        ref.invalidate(checkTopicSubscriptionProvider(topic));
        return true;
      },
      child: _SettingsOption(
        leading: CachedNetworkImage(
          imageUrl: widget.agency.logo ?? SalmonImages.agencyPlaceholder,
          imageBuilder: (context, imageProvider) => Padding(
            padding: const EdgeInsetsDirectional.only(
              end: 16,
            ),
            child: Image(
              image: imageProvider,
              width: 24,
            ),
          ),
          placeholder: (context, url) => const SizedBox.shrink(),
          errorWidget: (context, url, error) => CachedNetworkImage(
            imageUrl: SalmonImages.agencyPlaceholder,
            height: 36,
            width: 36,
            imageBuilder: (context, imageProvider) => Padding(
              padding: const EdgeInsetsDirectional.only(
                end: 16,
              ),
              child: Image(
                image: imageProvider,
              ),
            ),
            memCacheHeight: 256,
          ),
          memCacheHeight: 56,
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16),
        title: Text(widget.agency.enName!),
        trailing: Switch(
          value: isSubbed.value,
          onChanged: (_) {
            isSubbed.value = !isSubbed.value;

            final topic =
                NotifsController.generateTopicName(widget.agency.enName ?? '');

            if (_debounce?.isActive ?? false) _debounce?.cancel();
            _debounce = Timer(_timeout, () {
              ref.read(notifsControllerProvider).manageTopicSubscription(
                    topic: topic,
                    subscribe: isSubbed.value,
                  );
            });
          },
        ),
      ),
    );
  }
}
