import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../helpers/salmon_const.dart';

final supportedLocalesProvider = Provider<List<Locale>>((ref) {
  return const [
    Locale(SalmonConst.en),
    Locale(SalmonConst.ar),
  ];
});
