import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:salmon/controllers/notifs/notifs_controller.dart';
import 'package:salmon/helpers/salmon_anims.dart';
import 'package:salmon/helpers/salmon_extensions.dart';
import 'package:salmon/providers/agency/agency_provider.dart';
import 'package:salmon/providers/check_topic_subscription/check_topic_subscription_provider.dart';
import 'package:salmon/providers/notif_controller/notif_controller_provider.dart';
import 'package:salmon/views/feed/components/post_data.dart';
import 'package:salmon/views/shared/salmon_tag_chip/salmon_tag_chip.dart';

class PostNotificationChip extends StatefulHookConsumerWidget {
  const PostNotificationChip({
    super.key,
  });

  @override
  ConsumerState<PostNotificationChip> createState() =>
      _PostNotificationChipState();
}

class _PostNotificationChipState extends ConsumerState<PostNotificationChip> {
  bool _initialValue = false;

  static final _upperBound = 40.normalized(maxVal: 125);

  @override
  Widget build(BuildContext context) {
    final post = PostData.of(context)!.data;
    final agency = ref.watch(agencyProvider(post.createdBy!));
    final isSubbed = useState(false);
    final animController = useAnimationController(
      duration: const Duration(),
      upperBound: _upperBound,
    );
    final isLoaded = useState(false);

    useEffect(() {
      agency.whenData((value) {
        ref
            .read(checkTopicSubscriptionProvider(
                NotifsController.generateTopicName(value?.enName ?? '')))
            .whenData((value) {
          isSubbed.value = value ?? false;
          _initialValue = isSubbed.value;
        });
      });
      return null;
    }, const []);

    useEffect(() {
      if (!isLoaded.value) return;

      isSubbed.value ? animController.forward() : animController.reverse();

      return null;
    }, [isLoaded.value, isSubbed.value]);

    return WillPopScope(
      onWillPop: () async {
        if (isSubbed.value != _initialValue) {
          ref.read(notifControllerProvider).manageTopicSubscription(
                topic:
                    NotifsController.generateTopicName(agency.value!.enName!),
                subscribe: isSubbed.value,
              );

          ref.invalidate(checkTopicSubscriptionProvider(
              NotifsController.generateTopicName(agency.value?.enName ?? '')));
        }

        return true;
      },
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 370),
        child: agency.hasValue
            ? Padding(
                padding: const EdgeInsetsDirectional.only(end: 12),
                child: SalmonTagChip(
                  onTap: () {
                    isSubbed.value = !isSubbed.value;
                  },
                  maxWidth: 220,
                  child: AnimatedSize(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOut,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Lottie.asset(
                          SalmonAnims.bell,
                          controller: animController,
                          onLoaded: (comp) {
                            animController.duration =
                                comp.duration * _upperBound;
                            isLoaded.value = true;
                          },
                          height: 32,
                        ),
                        if (!isSubbed.value)
                          Expanded(
                            child: Text(
                              agency.value?.enName ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              )
            : const SizedBox.shrink(),
      ),
    );
  }
}
