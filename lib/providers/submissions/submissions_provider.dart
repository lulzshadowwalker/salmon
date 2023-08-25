import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:salmon/controllers/submissions/submissions_controller.dart';
import 'package:salmon/models/submission.dart';

final submissionsProvider = StreamProvider<List<Submission>>((ref) {
  return ref.watch(submissionsControllerProvider).submissions;
});
