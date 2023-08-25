import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:salmon/helpers/salmon_helpers.dart';

import '../../models/poll.dart';
import '../../models/poll_vote.dart';
import '../../providers/a12n/a12n_provider.dart';

final pollsControllerProvider =
    Provider<PollsController>((ref) => PollsController(ref));

final class PollsController {
  PollsController(this.ref);

  final Ref ref;

  final _db = FirebaseFirestore.instance;
  final _log = SalmonHelpers.getLogger('PollsController');

  Future<List<Poll>> get polls async =>
      await _db.collection('polls').limit(5).orderBy('dateCreated').get().then(
            (query) => query.docs
                .map(
                  (doc) => Poll.fromMap(doc.data()),
                )
                .toList(),
          );

  Future<void> vote({
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
          .collection('polls')
          .doc(poll.id)
          .collection('pollVotes')
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

  Future<PollVote?> check(Poll poll) async {
    try {
      final uid = ref.read(a12nProvider).userId;

      final res = await _db
          .collection('polls')
          .doc(poll.id)
          .collection('pollVotes')
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
}
