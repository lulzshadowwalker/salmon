import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:salmon/providers/db/remote_db/remote_db_provider.dart';

import '../../models/comment.dart';

final postCommentsProvider =
    StreamProvider.autoDispose.family<List<Comment?>, String>((ref, postId) {
  return ref.watch(remoteDbProvider).comments(postId);
});
