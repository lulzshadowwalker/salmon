import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:salmon/providers/notifs_controller/notifs_controller_provider.dart';

final checkTopicSubscriptionProvider =
    FutureProvider.family.autoDispose<bool?, String>(
  (ref, topic) =>
      ref.watch(notifsControllerProvider).checkTopicSubscription(topic),
);
