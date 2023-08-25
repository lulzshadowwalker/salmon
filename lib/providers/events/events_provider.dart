import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:salmon/models/event.dart';
import 'package:salmon/providers/db/remote_db/remote_db_provider.dart';

final eventsProvider = FutureProvider<List<Event>>(
  (ref) => ref.watch(remoteDbProvider).events,
);
