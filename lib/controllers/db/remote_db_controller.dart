// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:salmon/controllers/notif/notif_controller.dart';
import 'package:salmon/helpers/salmon_extensions.dart';
import 'package:salmon/helpers/salmon_helpers.dart';
import 'package:salmon/models/comment.dart';
import 'package:salmon/models/enums/notif_type.dart';
import 'package:salmon/models/poll.dart';
import 'package:salmon/models/salmon_user.dart';
import 'package:salmon/models/submission.dart';
import 'package:salmon/providers/a12n/a12n_provider.dart';
import 'package:salmon/providers/salmon_user_credentials/salmon_user_credentials_provider.dart';
import 'package:salmon/providers/storage/remote_storage/remote_storage_provider.dart';
import 'package:uuid/uuid.dart';
import '../../l10n/l10n_imports.dart';
import '../../models/agency.dart';
import '../../models/poll_vote.dart';
import '../../models/post.dart';
import '../../models/typedefs/user_id.dart';

final class RemoteDbController {
  RemoteDbController(this.ref);
  final Ref ref;

  static final _db = FirebaseFirestore.instance;
  static final _log = SalmonHelpers.getLogger('RemoteDbController');

  /* STRING CONST ------------------------------------------------------------- */
  static const String _cUsers = 'users';
  static const String _cAgencies = 'agencies';
  static const String _cPosts = 'posts';
  static const String _cSubmissions = 'submissions';
  static const String _aCreatedOn = 'created_on';
  static const String _aId = 'id';
  static const String _aFcmToken = 'fcm_token';
  static const String _cClaps = 'claps';
  static const String _aCount = 'count';
  static const String _aUserId = 'user_id';
  static const String _aClapCount = 'clap_count';
  static const String _cComments = 'comments';
  static const String _aComment = 'comment';
  static const String _aPostId = 'post_id';
  static const String _aName = 'name';
  static const String _aUrl = 'url';
  static const String _aMimeType = 'mime_type';
  static const String _cPolls = "polls";
  static const String _cPollVotes = "pollVotes";
  /* -------------------------------------------------------------------------- */

  Future<void> createUserRecord({
    required BuildContext context,
    required UserId uid,
  }) async {
    try {
      var cred = ref.read(salmonUserCredentialsProvider).credentials;

      final pfpFile = cred.pfpRaw;

      if (pfpFile != null) {
        final data = await pfpFile.readAsBytes();

        final pfpUrl = await ref.read(remoteStorageProvider).upload(
              context: context,
              childName: _cUsers,
              file: data,
            );

        cred = cred.copyWith(
          pfpUrl: pfpUrl,
        );
      }

      await _db.collection(_cUsers).doc(uid).set(
            cred.toMap()
              ..addAll(
                {
                  _aCreatedOn: DateTime.now().toUtc(),
                  _aId: uid,
                  _aFcmToken: kDebugMode ? '' : await NotifController.fcmToken,
                },
              ),
          );

      _log.v('''
registered new user with details:
  ${cred.toMap()}
''');
    } catch (e) {
      SalmonHelpers.handleException(context: context, e: e, logger: _log);
    }
  }

  Stream<SalmonUser> get userData {
    final uid = ref.read(a12nProvider).userId;
    final isGuest = ref.read(a12nProvider).isGuest;
    if (uid == null || isGuest) return const Stream.empty();

    return _db
        .collection(_cUsers)
        .doc(uid)
        .snapshots()
        .map((snap) => SalmonUser.fromMap(snap.data()!));
  }

  Future<void> updateUser(
      BuildContext context, Map<String, dynamic> data) async {
    try {
      final uid = ref.read(a12nProvider).userId;

      if (data['pfp_raw'] != null) {
        final pfpUrl = await ref.read(remoteStorageProvider).upload(
              context: context,
              childName: _cUsers,
              file: data['pfp_raw'],
            );

        data.addAll({'pfp': pfpUrl});
      }

      await _db.collection(_cUsers).doc(uid).update(data.compact);

      NotifController.showPopup(
        context: context,
        message: SL.of(context).infoHasBeenUpdated,
        type: NotifType.success,
      );
    } catch (e) {
      SalmonHelpers.handleException(context: context, e: e, logger: _log);
    }
  }

  Stream<List<Agency>> get agencies {
    return _db.collection(_cAgencies).snapshots().map(
          (query) => query.docs
              .map(
                (doc) => Agency.fromMap(doc.data()),
              )
              .toList(),
        );
  }

  Stream<List<Post>> get posts {
    return _db
        .collection(_cPosts)
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

  Stream<List<Submission>> get submissions {
    final uid = ref.read(a12nProvider).userId;

    return _db
        .collection(_cSubmissions)
        .where('submitted_by', isEqualTo: uid)
        // .orderBy('date_created', descending: true)
        .snapshots()
        .map(
          (query) => query.docs
              .map(
                (doc) => Submission.fromMap(doc.data()),
              )
              .toList(),
        );
  }

  Future<List<Poll>> get polls async =>
      await _db.collection(_cPolls).limit(5).orderBy('dateCreated').get().then(
            (query) => query.docs
                .map(
                  (doc) => Poll.fromMap(doc.data()),
                )
                .toList(),
          );

  Future<void> votePoll({
    required Poll poll,
    required String optionId,
  }) async {
    try {
      final uid = ref.read(a12nProvider).userId;
      final vote = PollVote(
        id: uid,
        userId: uid,
        optionId: optionId,
      );

      final data = vote.toMap()
        ..addAll({
          'dateCreated': DateTime.now().toUtc(),
        });

      await _db
          .collection(_cPolls)
          .doc(poll.id)
          .collection(_cPollVotes)
          .doc(uid)
          .set(data);

      _log.v('''
✨ Poll Vote
poll: ${poll.toMap()}
vote: $data
''');
    } catch (e) {
      SalmonHelpers.handleException(e: e, logger: _log);
    }
  }

  Future<PollVote?> checkVote(Poll poll) async {
    try {
      final uid = ref.read(a12nProvider).userId;

      final res = await _db
          .collection(_cPolls)
          .doc(poll.id)
          .collection(_cPollVotes)
          .where('userId', isEqualTo: uid)
          .get()
          .then((query) {
        final doc = query.docs.firstOrNull;
        return doc != null ? PollVote.fromMap(doc.data()) : null;
      });

      _log.v('''
✨ Poll Vote Check 
vote: ${res?.toMap()}
''');

      return res;
    } catch (e) {
      SalmonHelpers.handleException(e: e, logger: _log);
      return null;
    }
  }

  Future<void> createSubmission({
    required BuildContext context,
    required Submission submission,
  }) async {
    try {
      final uploads = submission.attachments?.map((e) async {
        (e as XFile);

        final bytes = await e.readAsBytes();

        final url = await ref.read(remoteStorageProvider).upload(
              context: context,
              childName: 'submissions',
              file: bytes,
            );

        final mime = e.mimeType ??
            lookupMimeType(
              e.name,
              headerBytes: bytes,
            );

        return {
          _aUrl: url,
          _aMimeType: mime,
          _aName: e.name,
        };
      });

      final attachments = await Future.wait((uploads ?? []).cast());

      final uid = ref.read(a12nProvider).userId;
      final id = const Uuid().v4();

      final data = submission.toMap()
        ..['attachments'] = attachments
        ..['submitted_by'] = uid
        ..['status'] = 'submitted'
        ..['id'] = id
        ..addAll(
          {
            'submitted_at': DateTime.now().toUtc(),
          },
        );
      await _db.collection(_cSubmissions).doc(id).set(data);

      _log.v('''
created submission successfully with the data
$data
''');

      NotifController.showPopup(
        context: context,
        message: 'we shall be in touch shortly', // TODO tr
        type: NotifType.success,
      );
    } catch (e) {
      SalmonHelpers.handleException(context: context, e: e, logger: _log);
    }
  }

  Future<void> clap(Post post, int count) async {
    try {
      final uid = ref.read(a12nProvider).userId;
      final postRef = _db.collection(_cPosts).doc(post.id);
      final clapRef = postRef.collection(_cClaps).doc(uid);

      await _db.runTransaction((trans) async {
        final oldPostClapCount = await trans
                .get(postRef)
                .then((value) => value.data()?[_aClapCount] as int?) ??
            0;

        final oldUserClapCount = await trans
                .get(clapRef)
                .then((value) => value.data()?[_aCount] as int?) ??
            0;

        trans.set(
          clapRef,
          {
            _aCount: count,
            _aUserId: uid,
          },
          SetOptions(merge: true),
        );

        final newPostClapCount = oldPostClapCount + (count - oldUserClapCount);
        trans.set(
          postRef,
          {
            _aClapCount: newPostClapCount,
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

  Future<Agency?> fetchAgency(String id) async {
    try {
      return await _db.collection(_cAgencies).doc(id).get().then(
            (snap) => Agency.fromMap(snap.data()!),
          );
    } catch (e) {
      SalmonHelpers.handleException(e: e, logger: _log);
      return null;
    }
  }

  Future<int?> fetchUserClapCount(String id) async {
    try {
      final uid = ref.read(a12nProvider).userId;

      return await _db
          .collection(_cPosts)
          .doc(id)
          .collection(_cClaps)
          .doc(uid)
          .get()
          .then(
            (snap) => snap.data()?[_aCount] ?? 0,
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
        _aUserId: uid,
        _aComment: comment,
        _aCreatedOn: DateTime.now().toUtc(),
        _aPostId: post.id,
        _aId: id,
      };

      await _db
          .collection(_cPosts)
          .doc(post.id)
          .collection(_cComments)
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
          .collection(_cPosts)
          .doc(postId)
          .collection(_cComments)
          .orderBy(
            _aCreatedOn,
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

  Future<SalmonUser?> fetchUser(String userId) async {
    try {
      return await _db.collection(_cUsers).doc(userId).get().then(
            (snap) => SalmonUser.fromMap(snap.data()!),
          );
    } catch (e) {
      SalmonHelpers.handleException(e: e, logger: _log);
      return null;
    }
  }

  Future<int?> fetchCommentCount(String id) async {
    try {
      return await _db
          .collection(_cPosts)
          .doc(id)
          .collection(_cComments)
          .count()
          .get()
          .then((value) => value.count);
    } catch (e) {
      SalmonHelpers.handleException(e: e, logger: _log);
      return null;
    }
  }
}
