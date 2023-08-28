import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../home/components/home_app_bar.dart';
import '../salmon_drawer/components/salmon_drawer_components.dart';

class Analytics extends ConsumerWidget {
  const Analytics({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Scaffold(
      drawer: SalmonDrawer(),
      appBar: HomeAppBar(),
      body: Center(
        child: Text(
          'Statistics',
        ),
      ),
    );
  }
}
