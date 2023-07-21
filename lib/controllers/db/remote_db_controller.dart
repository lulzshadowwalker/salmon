// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:salmon/controllers/notif/notif_controller.dart';
import 'package:salmon/helpers/salmon_extensions.dart';
import 'package:salmon/helpers/salmon_helpers.dart';
import 'package:salmon/models/enums/notif_type.dart';
import 'package:salmon/models/salmon_user.dart';
import 'package:salmon/models/submission.dart';
import 'package:salmon/providers/a12n/a12n_provider.dart';
import 'package:salmon/providers/salmon_user_credentials/salmon_user_credentials_provider.dart';
import 'package:salmon/providers/storage/remote_storage/remote_storage_provider.dart';
import 'package:uuid/uuid.dart';
import '../../l10n/l10n_imports.dart';
import '../../models/agency.dart';
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
  /* -------------------------------------------------------------------------- */

  Future<void> createUserRecord({
    required BuildContext context,
    required UserId uid,
  }) async {
    try {
      var cred = ref.read(salmonUserCredentialsProvider).credentials;

      final pfpRaw = cred.pfpRaw;
      if (pfpRaw != null) {
        final pfpUrl = await ref.read(remoteStorageProvider).upload(
              context: context,
              childName: _cUsers,
              file: pfpRaw,
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
        .collection(_cPosts)
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

  Future<void> createSubmission({
    required BuildContext context,
    required Submission submission,
  }) async {
    try {
      final uploads = submission.attachments?.map(
        (e) async => await ref.read(remoteStorageProvider).upload(
              context: context,
              childName: 'submissions',
              file: e,
            ),
      );

      var urls = <String>[];
      if (uploads != null) {
        urls = await Future.wait(uploads).then(
          (value) => value.toCompactMap.toList(),
        );
      }

      final uid = ref.read(a12nProvider).userId;
      final id = const Uuid().v4();

      final data = submission.toMap()
        ..['attachments'] = urls
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
    } catch (e) {
      SalmonHelpers.handleException(context: context, e: e, logger: _log);
    }
  }
}
