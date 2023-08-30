import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:salmon/controllers/submissions/submissions_controller.dart';

final submissionsCountProvider = FutureProvider<int?>((ref) {
  return ref.read(submissionsControllerProvider).submissionsCount();
});

final resolvedSubmissionsCountProvider = FutureProvider<int?>((ref) {
  return ref.read(submissionsControllerProvider).resolvedSubmissionsCount();
});
