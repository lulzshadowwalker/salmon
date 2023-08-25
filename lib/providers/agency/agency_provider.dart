import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:salmon/controllers/agencies/agencies_controller.dart';

import '../../models/agency.dart';

final agencyProvider = FutureProvider.family<Agency?, String>(
  (ref, id) => ref.read(agenciesControllerProvider).fetch(id),
);
