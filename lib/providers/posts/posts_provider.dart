import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:salmon/controllers/posts/posts_controller.dart';
import 'package:salmon/providers/content_filter/content_filter_provider.dart';

import '../../models/post.dart';

final postsProvider = StreamProvider<List<Post>>(
  (ref) => ref.watch(postsControllerProvider).posts,
);

final filteredPostsProvider =
    Provider.autoDispose<AsyncValue<List<Post>>>((ref) {
  final selected = ref.watch(contentFilterProvider).tags.map((e) => e.id);

  return ref.watch(postsProvider).whenData(
        (posts) => posts
            .where(
              (e) => selected.contains(e.createdBy),
            )
            .toList(),
      );
});
