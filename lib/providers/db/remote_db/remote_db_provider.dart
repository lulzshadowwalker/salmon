import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:salmon/controllers/db/remote_db_controller.dart';

final remoteDbProvider = Provider<RemoteDbController>((ref) {
  return RemoteDbController(ref);
});
