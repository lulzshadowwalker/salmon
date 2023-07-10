import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:salmon/models/salmon_user.dart';
import 'package:salmon/providers/db/remote_db/remote_db_provider.dart';

part 'salmon_user_provider.g.dart';

@riverpod
Stream<SalmonUser> salmonUser(SalmonUserRef ref) {
  return ref.watch(remoteDbProvider).userData;
}
