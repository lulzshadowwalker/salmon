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

    ref.listen(
      checkTopicSubscriptionProvider(
        NotifsController.generateTopicName(widget.agency.enName ?? ''),
      ),
      (previous, next) {
        isSubbed.value = next.value ?? false;
      },
    );

    return _SettingsOption(
      leading: CachedNetworkImage(
        imageUrl: widget.agency.logo ?? SalmonImages.notFound,
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
    );
  }
}