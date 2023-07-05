import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:salmon/helpers/salmon_helpers.dart';
import 'package:salmon/providers/a12n/a12n_provider.dart';
// ignore: depend_on_referenced_packages
import 'package:uuid/uuid.dart';

final class RemoteStorageController {
  RemoteStorageController(this.ref);
  final Ref ref;

  final _firebaseStorage = FirebaseStorage.instance;
  final _log = SalmonHelpers.getLogger('RemoteStorageController');

  Future<String?> upload({
    required BuildContext context,
    required String childName,
    required Uint8List file,
    String? fileId,
  }) async {
    try {
      final uid = ref.read(a12nProvider).userId;
      if (uid == null) throw Exception('user id is null');
      final String userId = uid;

      fileId ??= const Uuid().v4();

      final pathRef =
          _firebaseStorage.ref().child(userId).child(childName).child(fileId);

      final snapshot = await pathRef.putData(file);

      final String downloadUrl = await snapshot.ref.getDownloadURL();

      _log.v('file uploaded successfully');

      return downloadUrl;
    } catch (e) {
      SalmonHelpers.handleException(context: context, e: e, logger: _log);
      return null;
    }
  }
}
