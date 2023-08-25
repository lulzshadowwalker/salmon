import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:salmon/controllers/posts/posts_controller.dart';

final commentCountProvider = FutureProvider.family.autoDispose<int?, String>(
  (ref, id) => ref.watch(postsControllerProvider).fetchCommentCount(id),
);
