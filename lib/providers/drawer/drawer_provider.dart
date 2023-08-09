import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../views/home/home.dart';

part 'drawer_provider.g.dart';

@Riverpod(keepAlive: true)
class DrawerPage extends _$DrawerPage {
  @override
  Widget build() {
    return const Home();
  }

  void set(Widget page) {
    if (state == page) return;

    state = page;
  }
}
