import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:salmon/models/poll.dart';
import 'package:salmon/models/poll_vote.dart';
import 'package:salmon/providers/db/remote_db/remote_db_provider.dart';

final checkVoteProvider =
    FutureProvider.family.autoDispose<PollVote?, Poll>((ref, poll) {
  return ref.watch(remoteDbProvider).checkVote(poll);
});
