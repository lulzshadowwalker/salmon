import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:salmon/providers/db/remote_db/remote_db_provider.dart';

import '../../models/salmon_user.dart';

final userProvider = FutureProvider.family<SalmonUser?, String>(
  (ref, userId) => ref.watch(remoteDbProvider).fetchUser(userId),
);
