import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:salmon/models/enums/notif_type.dart';
import 'package:salmon/providers/a12n/a12n_provider.dart';
import '../../controllers/notif/notif_controller.dart';

class Home extends ConsumerWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                NotifController.showPopup(
                  context: context,
                  message: 'Sucess',
                  type: NotifType.success,
                );
              },
              child: const Text('Success'),
            ),
            ElevatedButton(
              onPressed: () {
                NotifController.showPopup(
                  context: context,
                  message: 'Tip',
                  type: NotifType.tip,
                );
              },
              child: const Text('Tip'),
            ),
            ElevatedButton(
              onPressed: () {
                NotifController.showPopup(
                  context: context,
                  message: 'Error',
                  type: NotifType.oops,
                );
              },
              child: const Text('Error'),
            ),
            ElevatedButton(
              onPressed: () {
                NotifController.showPopup(
                  context: context,
                  message: 'Warning',
                  type: NotifType.warning,
                );
              },
              child: const Text('Warning'),
            ),
            OutlinedButton(
              onPressed: () => ref.read(a12nProvider).signOut(context),
              child: const Text('Sign out'),
            ),
          ],
        ),
      ),
    );
  }
}
