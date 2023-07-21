import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../providers/drawer/drawer_provider.dart';

class Analytics extends ConsumerWidget {
  const Analytics({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: ElevatedButton(
            onPressed: () {
              ref.read(drawerStateProvider.notifier).toggle();
              HapticFeedback.heavyImpact();
            },
            child: const Text('tappitty tap'),
          ),
        ),
      ),
    );
  }
}
