import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:salmon/helpers/salmon_helpers.dart';

import '../../models/poll.dart';
import '../../models/poll_vote.dart';
import '../../providers/a12n/a12n_provider.dart';

part 'polls_controller.g.dart';

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

  Stream<List<PollVote?>> votes(String pollId) {
    try {
      return _db
          .collection('polls')
          .doc(pollId)
          .collection('pollVotes')
          .snapshots()
          .map(
            (query) => query.docs
                .map(
                  (doc) => PollVote.fromMap(doc.data()),
                )
                .toList(),
          );
    } catch (e) {
      SalmonHelpers.handleException(e: e, logger: _log);
      return const Stream.empty();
    }
  }

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

final pollsControllerProvider =
    Provider<PollsController>((ref) => PollsController(ref));

final pollVotesProvider = StreamProvider.family<List<PollVote?>, String>(
  (ref, pollId) => ref.watch(pollsControllerProvider).votes(pollId),
);

@Riverpod(keepAlive: true)
int pollOptVoteCount(PollOptVoteCountRef ref, String pollId, String optId) {
  final votes = ref.watch(pollVotesProvider(pollId)).value ?? [];

  return votes.where((v) => v?.optionId == optId).length;
}

@Riverpod(keepAlive: true)
double pollOptVotePercentage(
    PollOptVotePercentageRef ref, String pollId, String optId) {
  final totalCount = ref.watch(pollVotesProvider(pollId)).value?.length ?? 1;
  final optCount = ref.watch(pollOptVoteCountProvider(pollId, optId));

  print('''
  poll:- $pollId
  opt:- $optId
    totalCount:- $totalCount
    optCount:- $optCount
''');

  return (optCount * 100 / totalCount).clamp(0, 100);
}
