import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:salmon/helpers/salmon_helpers.dart';

import '../../models/agency.dart';

final agenciesControllerProvider =
    Provider<AgenciesController>((ref) => AgenciesController(ref));

final class AgenciesController {
  AgenciesController(this.ref);

  final Ref ref;

  final _db = FirebaseFirestore.instance;
  final _log = SalmonHelpers.getLogger('AgencyController');

  Future<Agency?> fetch(String id) async {
    try {
      return await _db.collection('agencies').doc(id).get().then(
            (snap) => Agency.fromMap(snap.data()!),
          );
    } catch (e) {
      SalmonHelpers.handleException(e: e, logger: _log);
      return null;
    }
  }

  Stream<List<Agency>> get enAgencies {
    return _db.collection('agencies').orderBy('en_name').snapshots().map(
          (query) => query.docs
              .map(
                (doc) => Agency.fromMap(doc.data()),
              )
              .toList(),
        );
  }

  Stream<List<Agency>> get arAgencies {
    return _db.collection('agencies').orderBy('ar_name').snapshots().map(
          (query) => query.docs
              .map(
                (doc) => Agency.fromMap(doc.data()),
              )
              .toList(),
        );
  }
}
