import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:salmon/providers/db/remote_db/remote_db_provider.dart';

import '../../models/agency.dart';

final agencyProvider = FutureProvider.family<Agency?, String>(
  (ref, id) => ref.read(remoteDbProvider).fetchAgency(id),
);
