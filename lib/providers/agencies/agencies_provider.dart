import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:salmon/controllers/agencies/agencies_controller.dart';
import 'package:salmon/helpers/salmon_const.dart';
import 'package:salmon/models/agency.dart';

final agenciesProvider = StreamProvider.family<List<Agency>, String>(
  (ref, lang) {
    return lang == SalmonConst.ar
        ? ref.watch(agenciesControllerProvider).arAgencies
        : ref.watch(agenciesControllerProvider).enAgencies;
  },
);
