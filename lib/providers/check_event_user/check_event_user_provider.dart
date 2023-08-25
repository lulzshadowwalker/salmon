import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:salmon/models/event.dart';
import 'package:salmon/models/salmon_user.dart';
import 'package:salmon/providers/db/remote_db/remote_db_provider.dart';

final checkEventUserProvider =
    FutureProvider.family.autoDispose<SalmonUser?, Event>((ref, event) {
  return ref.watch(remoteDbProvider).checkEventUser(event);
});
