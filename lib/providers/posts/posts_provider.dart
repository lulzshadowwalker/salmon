import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:salmon/controllers/posts/posts_controller.dart';

import '../../models/post.dart';

final postsProvider = StreamProvider<List<Post>>(
  (ref) => ref.watch(postsControllerProvider).posts,
);
