import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/enums/drawer_status.dart';
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
    ref.read(drawerStateProvider.notifier).toggle();
  }
}

@riverpod
class DrawerState extends _$DrawerState {
  @override
  DrawerStatus build() {
    return DrawerStatus.closed;
  }

  void toggle() {
    state =
        state == DrawerStatus.open ? DrawerStatus.closed : DrawerStatus.open;
  }

// ignore: avoid_public_notifier_properties
  bool get isOpen => state == DrawerStatus.open;
}
