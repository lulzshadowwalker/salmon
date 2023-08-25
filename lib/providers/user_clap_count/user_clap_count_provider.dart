import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:salmon/controllers/posts/posts_controller.dart';

final userClapCountProvider =
    FutureProvider.autoDispose.family<int?, String>((ref, postId) {
  return ref.read(postsControllerProvider).fetchUserClapCount(postId);
});
