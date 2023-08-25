import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:salmon/controllers/polls/polls_controller.dart';
import 'package:salmon/models/poll.dart';
import 'package:salmon/models/poll_vote.dart';

final checkVoteProvider =
    FutureProvider.family.autoDispose<PollVote?, Poll>((ref, poll) {
  return ref.watch(pollsControllerProvider).check(poll);
});
