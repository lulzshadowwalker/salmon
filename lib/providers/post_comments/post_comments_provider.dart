import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:salmon/controllers/posts/posts_controller.dart';

import '../../models/comment.dart';

final postCommentsProvider =
    StreamProvider.autoDispose.family<List<Comment?>, String>((ref, postId) {
  return ref.watch(postsControllerProvider).comments(postId);
});
