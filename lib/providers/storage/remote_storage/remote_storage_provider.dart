import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:salmon/controllers/storage/remote_storage_controller.dart';

final remoteStorageProvider = Provider<RemoteStorageController>((ref) {
  return RemoteStorageController(ref);
});
