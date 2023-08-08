import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:salmon/views/salmon_drawer/components/salmon_drawer_components.dart';
import '../../providers/drawer/drawer_provider.dart';

class Interface extends ConsumerWidget {
  const Interface({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final drawerPage = ref.watch(drawerPageProvider);

    return SalmonDrawer(
      page: drawerPage,
    );
  }
}
