import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:salmon/providers/db/remote_db/remote_db_provider.dart';

final agenciesProvider = StreamProvider(
  (ref) => ref.watch(remoteDbProvider).agencies,
);
