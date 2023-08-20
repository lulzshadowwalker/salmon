import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:salmon/providers/a12n/a12n_provider.dart';

import '../../router/salmon_router.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return SalmonRouter(ref).config;
});
