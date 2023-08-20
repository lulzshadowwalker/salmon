import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../providers/drawer/drawer_provider.dart';
import '../onboarding/onboarding.dart';

class Interface extends ConsumerWidget {
  const Interface({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final page = ref.watch(drawerPageProvider);
    return page;
  }
}
