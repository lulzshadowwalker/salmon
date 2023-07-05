import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:salmon/controllers/a12n/a12n_controller.dart';

final a12nProvider = Provider<A12nController>((ref) => A12nController(ref));
