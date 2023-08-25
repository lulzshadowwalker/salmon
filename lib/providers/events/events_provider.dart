import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:salmon/controllers/events/events_controller.dart';
import 'package:salmon/models/event.dart';

final eventsProvider = FutureProvider<List<Event>>(
  (ref) => ref.watch(eventsControllerProvider).events,
);
