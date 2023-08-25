import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:salmon/helpers/salmon_extensions.dart';
import 'package:salmon/helpers/salmon_helpers.dart';

import '../../l10n/l10n_imports.dart';
import '../../models/enums/notif_type.dart';
import '../../models/salmon_user.dart';
import '../../models/typedefs/user_id.dart';
import '../../providers/a12n/a12n_provider.dart';
import '../../providers/salmon_user_credentials/salmon_user_credentials_provider.dart';
import '../../providers/storage/remote_storage/remote_storage_provider.dart';
import '../notifs/notifs_controller.dart';

final usersControllerProvider =
    Provider<UsersController>((ref) => UsersController(ref));

final class UsersController {
  UsersController(this.ref);

  final Ref ref;

  final _db = FirebaseFirestore.instance;
  final _log = SalmonHelpers.getLogger('UserController');

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
              childName: 'users',
              file: data,
            );

        cred = cred.copyWith(
          pfpUrl: pfpUrl,
        );
      }

      await _db.collection('users').doc(uid).set(
            cred.toMap()
              ..addAll(
                {
                  'created_on': DateTime.now().toUtc(),
                  'id': uid,
                  'fcm_token':
                      kDebugMode ? '' : await NotifsController.fcmToken,
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

  Stream<SalmonUser> get currentUserData {
    final uid = ref.read(a12nProvider).userId;
    final isGuest = ref.read(a12nProvider).isGuest;
    if (uid == null || isGuest) return const Stream.empty();

    return _db
        .collection('users')
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
              childName: 'users',
              file: data['pfp_raw'],
            );

        data.addAll({'pfp': pfpUrl});
      }

      await _db.collection('users').doc(uid).update(data.compact);

      NotifsController.showPopup(
        context: context,
        message: SL.of(context).infoHasBeenUpdated,
        type: NotifType.success,
      );
    } catch (e) {
      SalmonHelpers.handleException(context: context, e: e, logger: _log);
    }
  }

  Future<SalmonUser?> fetchUser(String userId) async {
    try {
      return await _db.collection('users').doc(userId).get().then(
            (snap) => SalmonUser.fromMap(snap.data()!),
          );
    } catch (e) {
      SalmonHelpers.handleException(e: e, logger: _log);
      return null;
    }
  }
}
