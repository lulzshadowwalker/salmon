// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
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
                  'fcm_token': await NotifsController.fcmToken,
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
    if (uid == null || isGuest) return Stream.value(const SalmonUser());

    return _db
        .collection('users')
        .doc(uid)
        .snapshots()
        .map((snap) => SalmonUser.fromMap(snap.data()!));
  }

  Future<void> updateUser(
    BuildContext context,
    Map<String, dynamic> data,
  ) async {
    try {
      final d = data;
      final uid = ref.read(a12nProvider).userId;

      if (d['pfp_raw'] != null) {
        if (d['pfp_raw'] is XFile) {
          d['pfp_raw'] = await (d['pfp_raw'] as XFile).readAsBytes();
        }

        final pfpUrl = await ref.read(remoteStorageProvider).upload(
              context: context,
              childName: 'users',
              file: d['pfp_raw'],
            );
        d
          ..addAll({'pfp_url': pfpUrl})
          ..remove('pfp_raw');
      }

      await _db.collection('users').doc(uid).update(
            d.compact,
          );

      NotifsController.showPopup(
        context: context,
        message: SL.of(context).infoHasBeenUpdated,
        type: NotifType.success,
      );

      _log.v('user data updated');
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

  Future<int?> usersCount() async {
    try {
      return await _db
          .collection('users')
          .count()
          .get()
          .then((value) => value.count);
    } catch (e) {
      SalmonHelpers.handleException(e: e, logger: _log);
      return null;
    }
  }
}
