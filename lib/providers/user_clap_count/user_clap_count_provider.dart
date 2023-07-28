import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:salmon/providers/db/remote_db/remote_db_provider.dart';

final userClapCountProvider =
    FutureProvider.autoDispose.family<int?, String>((ref, postId) {
  return ref.read(remoteDbProvider).fetchUserClapCount(postId);
});
