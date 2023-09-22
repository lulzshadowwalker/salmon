import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:salmon/helpers/salmon_anims.dart';
import 'package:salmon/helpers/salmon_extensions.dart';

class Offline extends ConsumerWidget {
  const Offline({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FractionallySizedBox(
              widthFactor: 0.8,
              child: Lottie.asset(
                SalmonAnims.wifi,
                reverse: true,
              ),
            ),
            Text(
              context.sl.noInternetConnection,
              style: context.textTheme.titleMedium,
            )
          ],
        ),
      ),
    );
  }
}
