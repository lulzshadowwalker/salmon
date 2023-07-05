// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:salmon/controllers/notif/notif_controller.dart';
import 'package:salmon/helpers/salmon_helpers.dart';
import 'package:salmon/providers/salmon_user_credentials/salmon_user_credentials_provider.dart';
import 'package:salmon/providers/storage/remote_storage/remote_storage_provider.dart';
import '../../models/typedefs/user_id.dart';

final class RemoteDbController {
  RemoteDbController(this.ref);
  final Ref ref;

  static final _db = FirebaseFirestore.instance;
  static final _log = SalmonHelpers.getLogger('RemoteDbController');

  /* STRING CONST ------------------------------------------------------------- */
  static const String _cUsers = 'users';
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
                  _aFcmToken: await NotifController.fcmToken,
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
}
