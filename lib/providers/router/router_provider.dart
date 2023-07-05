import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../router/salmon_router.dart';

final routerProvider = Provider<SalmonRouter>((ref) {
  return SalmonRouter(ref);
});
