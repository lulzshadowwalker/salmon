import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:salmon/providers/db/remote_db/remote_db_provider.dart';

final commentCountProvider = FutureProvider.family.autoDispose<int?, String>(
  (ref, id) => ref.watch(remoteDbProvider).fetchCommentCount(id),
);
