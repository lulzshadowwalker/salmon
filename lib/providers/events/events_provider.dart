import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:salmon/controllers/events/events_controller.dart';
import 'package:salmon/models/event.dart';

import '../content_filter/content_filter_provider.dart';

final eventsProvider = FutureProvider<List<Event>>(
  (ref) => ref.watch(eventsControllerProvider).events,
);

final filteredEventsProvider =
    Provider.autoDispose.family<AsyncValue<List<Event>>, String>((ref, lang) {
  final selected = ref.watch(contentFilterProvider(lang)).tags.map((e) => e.id);

  return ref.watch(eventsProvider).whenData(
        (events) => events
            .where(
              (e) => selected.contains(e.createdBy),
            )
            .toList(),
      );
});
