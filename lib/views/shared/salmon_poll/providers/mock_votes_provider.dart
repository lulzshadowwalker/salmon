// import 'package:go_router/go_router.dart';
// import 'package:riverpod_annotation/riverpod_annotation.dart';
// import 'package:salmon/controllers/polls/polls_controller.dart';
// import 'package:salmon/models/poll_vote.dart';
// import 'package:salmon/providers/a12n/a12n_provider.dart';

// part 'mock_votes_provider.g.dart';

// @Riverpod(keepAlive: true)
// class AsyncMockVotes extends _$AsyncMockVotes {
//   AsyncMockVotes(this.pollId);
//   final String pollId;

//   @override
//   FutureOr<List<PollVote?>> build() async {
//     return ref.read(pollVotesProvider(pollId).future);
//   }

//   void vote(String optId) async {
//     final uid = ref.read(a12nProvider).userId;
//     final vote = (state.value ?? []).firstWhere((vote) => vote?.userId == uid);

//     if (vote != null) {
//       final i = (state.value ?? []).indexOf(vote);
//       state.value?[i] = vote.copyWith(optionId: optId);
//     }
//   }
// }

// @Riverpod(keepAlive: true)
// int mockPollOptVoteCount(
//   MockPollOptVoteCountRef ref,
//   String pollId,
//   String optId,
// ) {
//   final votes = ref.watch(pollVotesProvider(pollId)).value ?? [];

//   return votes.where((v) => v?.optionId == optId).length;
// }

// @Riverpod(keepAlive: true)
// double mockPollOptVotePercentage(
//   MockPollOptVotePercentageRef ref,
//   String pollId,
//   String optId,
// ) {
//   final totalCount = ref.watch(pollVotesProvider(pollId)).value?.length ?? 1;
//   final optCount = ref.watch(pollOptVoteCountProvider(pollId, optId));

//   print('''
//   poll:- $pollId
//   opt:- $optId
//     totalCount:- $totalCount
//     optCount:- $optCount
// ''');

//   return (optCount * 100 / totalCount).clamp(0, 100);
// }
