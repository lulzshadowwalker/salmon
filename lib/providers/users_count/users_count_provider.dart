import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:salmon/controllers/users/users_controller.dart';

final usersCountProvider = FutureProvider<int?>((ref) {
  return ref.read(usersControllerProvider).usersCount();
});
