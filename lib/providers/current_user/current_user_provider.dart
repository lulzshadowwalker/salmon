import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:salmon/controllers/users/users_controller.dart';
import 'package:salmon/models/salmon_user.dart';
import 'package:salmon/providers/a12n/a12n_provider.dart';

final currentUserProvider = StreamProvider<SalmonUser?>(
  (ref) {
    final u = ref.watch(authStateProvider);
    if (u.value == null) {
      ref.invalidateSelf();
    }

    return ref.watch(usersControllerProvider).currentUserData;
  },
);
