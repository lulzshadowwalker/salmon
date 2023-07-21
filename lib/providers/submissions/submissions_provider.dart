import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:salmon/models/submission.dart';
import 'package:salmon/providers/db/remote_db/remote_db_provider.dart';

final submissionsProvider = StreamProvider<List<Submission>>((ref) {
  return ref.watch(remoteDbProvider).submissions;
});
