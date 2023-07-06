import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/typedefs/index.dart';

part 'home_provider.g.dart';

@riverpod
class Home extends _$Home {
  @override
  Index build() => 0;

  void set(Index index) => state = index;
}
