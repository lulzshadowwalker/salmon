import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:salmon/controllers/users/users_controller.dart';

import '../../models/salmon_user.dart';

final userProvider = FutureProvider.family<SalmonUser?, String>(
  (ref, userId) => ref.watch(usersControllerProvider).fetchUser(userId),
);
