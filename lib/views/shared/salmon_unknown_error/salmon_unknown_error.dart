import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:salmon/helpers/salmon_anims.dart';

class SalmonUnknownError extends StatelessWidget {
  const SalmonUnknownError({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FractionallySizedBox(
        widthFactor: 0.5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              SalmonAnims.errorCone,
              repeat: true,
              reverse: true,
            ),
            const Text(
              'Unkown error has occurred',
            ),
          ],
        ),
      ),
    );
  }
}
