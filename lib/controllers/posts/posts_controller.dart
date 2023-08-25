import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:salmon/helpers/salmon_helpers.dart';
import 'package:uuid/uuid.dart';

import '../../models/comment.dart';
import '../../models/post.dart';
import '../../providers/a12n/a12n_provider.dart';

final postsControllerProvider =
    Provider<PostsController>((ref) => PostsController(ref));

final class PostsController {
  PostsController(this.ref);

  final Ref ref;

  final _db = FirebaseFirestore.instance;
  final _log = SalmonHelpers.getLogger('PostsController');

  Stream<List<Post>> get posts {
    return _db
        .collection('posts')
        .orderBy('date_created', descending: true)
        .snapshots()
        .map(
          (query) => query.docs
              .map(
                (doc) => Post.fromMap(doc.data()),
              )
              .toList(),
        );
  }

  Future<int?> fetchUserClapCount(String id) async {
    try {
      final uid = ref.read(a12nProvider).userId;

      return await _db
          .collection('posts')
          .doc(id)
          .collection('claps')
          .doc(uid)
          .get()
          .then(
            (snap) => snap.data()?['count'] ?? 0,
          );
    } catch (e) {
      SalmonHelpers.handleException(e: e, logger: _log);
      return null;
    }
  }

  Future<void> comment({
    required Post post,
    required String comment,
  }) async {
    try {
      final uid = ref.read(a12nProvider).userId;
      final id = const Uuid().v4();

      final data = {
        'user_id': uid,
        'comment': comment,
        'created_on': DateTime.now().toUtc(),
        'post_id': post.id,
        'id': id,
      };

      await _db
          .collection('posts')
          .doc(post.id)
          .collection('comments')
          .doc(id)
          .set(
            data,
            SetOptions(merge: true),
          );

      _log.v('''
post: ${post.enTitle} (id: ${post.id})
user has added a comment "$comment"
''');
    } catch (e) {
      SalmonHelpers.handleException(e: e, logger: _log);
    }
  }

  Stream<List<Comment?>> comments(String postId) {
    try {
      return _db
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .orderBy(
            'created_on',
            descending: true,
          )
          .snapshots()
          .map(
            (query) => query.docs
                .map(
                  (doc) => Comment.fromMap(doc.data()),
                )
                .toList(),
          );
    } catch (e) {
      SalmonHelpers.handleException(e: e, logger: _log);
      return const Stream.empty();
    }
  }

  Future<void> clap(Post post, int count) async {
    try {
      final uid = ref.read(a12nProvider).userId;
      final postRef = _db.collection('posts').doc(post.id);
      final clapRef = postRef.collection('claps').doc(uid);

      await _db.runTransaction((trans) async {
        final oldPostClapCount = await trans
                .get(postRef)
                .then((value) => value.data()?['clap_count'] as int?) ??
            0;

        final oldUserClapCount = await trans
                .get(clapRef)
                .then((value) => value.data()?['count'] as int?) ??
            0;

        trans.set(
          clapRef,
          {
            'count': count,
            'user_id': uid,
          },
          SetOptions(merge: true),
        );

        final newPostClapCount = oldPostClapCount + (count - oldUserClapCount);
        trans.set(
          postRef,
          {
            'clap_count': newPostClapCount,
          },
          SetOptions(merge: true),
        );

        _log.v('''

post: ${post.enTitle} (id: ${post.id})
user has clapped $count times
total claps: $newPostClapCount claps
''');
      });
    } catch (e) {
      SalmonHelpers.handleException(e: e, logger: _log);
    }
  }

  Future<int?> fetchCommentCount(String id) async {
    try {
      return await _db
          .collection('posts')
          .doc(id)
          .collection('comments')
          .count()
          .get()
          .then((value) => value.count);
    } catch (e) {
      SalmonHelpers.handleException(e: e, logger: _log);
      return null;
    }
  }
}
