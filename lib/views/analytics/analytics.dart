import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:salmon/views/shared/app_bar_divider/app_bar_divider.dart';
import '../../l10n/l10n_imports.dart';
import '../salmon_drawer/components/salmon_drawer_components.dart';
import '../shared/menu_button/menu_button.dart';

class Analytics extends ConsumerWidget {
  const Analytics({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        leading: const MenuButton(),
        title: Text(SL.of(context).settings),
        bottom: const AppBarDivider(),
      ),
      drawer: const Drawer(child: SalmonDrawer()),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: ElevatedButton(
            onPressed: () {},
            child: const Text('tappitty tap'),
          ),
        ),
      ),
    );
  }
}
