import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:salmon/providers/notif_controller/notif_controller_provider.dart';

final checkTopicSubscriptionProvider = FutureProvider.family<bool?, String>(
  (ref, topic) =>
      ref.watch(notifControllerProvider).checkTopicSubscription(topic),
);
