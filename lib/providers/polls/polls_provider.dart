import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:salmon/controllers/polls/polls_controller.dart';
import 'package:salmon/models/poll.dart';

final pollsProvider = FutureProvider<List<Poll>>(
  (ref) => ref.watch(pollsControllerProvider).polls,
);
