import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:salmon/controllers/events/events_controller.dart';
import 'package:salmon/models/event.dart';
import 'package:salmon/models/salmon_user.dart';

final eventUsersProvider = FutureProvider.family<List<SalmonUser>?, Event>(
  (ref, event) {
    return ref.watch(eventsControllerProvider).interestedUsers(event);
  },
);
