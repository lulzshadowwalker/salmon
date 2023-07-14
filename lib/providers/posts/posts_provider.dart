import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:salmon/models/salmon_user.dart';
import 'package:salmon/providers/db/remote_db/remote_db_provider.dart';

import '../../models/post.dart';

final postsProvider = StreamProvider<List<Post>>(
  (ref) => ref.watch(remoteDbProvider).posts,
);
