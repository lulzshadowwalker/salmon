import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:salmon/controllers/agencies/agencies_controller.dart';

final agenciesProvider = StreamProvider(
  (ref) => ref.watch(agenciesControllerProvider).agencies,
);
