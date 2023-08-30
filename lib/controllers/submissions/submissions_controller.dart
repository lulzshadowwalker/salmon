// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:salmon/helpers/salmon_extensions.dart';
import 'package:salmon/helpers/salmon_helpers.dart';
import 'package:uuid/uuid.dart';

import '../../models/enums/notif_type.dart';
import '../../models/submission.dart';
import '../../providers/a12n/a12n_provider.dart';
import '../../providers/storage/remote_storage/remote_storage_provider.dart';
import '../notifs/notifs_controller.dart';

final submissionsControllerProvider =
    Provider<SubmissionsController>((ref) => SubmissionsController(ref));

final class SubmissionsController {
  SubmissionsController(this.ref);

  final Ref ref;

  final _db = FirebaseFirestore.instance;
  final _log = SalmonHelpers.getLogger('SubmissionsController');

  Stream<List<Submission>> get submissions {
    final uid = ref.read(a12nProvider).userId;

    return _db
        .collection('submissions')
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

  Future<void> submit({
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
          'url': url,
          'mime_type': mime,
          'name': e.name,
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
      await _db.collection('submissions').doc(id).set(data);

      _log.v('''
created submission successfully with the data
$data
''');

      NotifsController.showPopup(
        context: context,
        message: context.sl.inTouchShortly,
        type: NotifType.success,
      );
    } catch (e) {
      SalmonHelpers.handleException(context: context, e: e, logger: _log);
    }
  }

  Future<int?> submissionsCount() async {
    try {
      return await _db
          .collection('submissions')
          .count()
          .get()
          .then((value) => value.count);
    } catch (e) {
      SalmonHelpers.handleException(e: e, logger: _log);
      return null;
    }
  }

  Future<int?> resolvedSubmissionsCount() async {
    try {
      return await _db
          .collection('submissions')
          .where('status', isEqualTo: 'resolved')
          .count()
          .get()
          .then((value) => value.count);
    } catch (e) {
      SalmonHelpers.handleException(e: e, logger: _log);
      return null;
    }
  }
}
