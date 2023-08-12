import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:salmon/models/salmon_user.dart';
import 'package:salmon/providers/a12n/a12n_provider.dart';
import 'package:salmon/providers/db/remote_db/remote_db_provider.dart';

final currentUserProvider = StreamProvider<SalmonUser>(
  (ref) {
    ref.watch(authStateProvider);
    return ref.watch(remoteDbProvider).userData;
  },
);
