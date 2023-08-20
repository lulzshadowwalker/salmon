import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:salmon/models/poll.dart';
import 'package:salmon/providers/db/remote_db/remote_db_provider.dart';

final pollsProvider = FutureProvider<List<Poll>>(
  (ref) => ref.watch(remoteDbProvider).polls,
);
