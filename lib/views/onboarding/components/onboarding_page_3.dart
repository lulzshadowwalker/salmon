import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lottie/lottie.dart';
import 'package:salmon/helpers/salmon_anims.dart';
import 'package:salmon/helpers/salmon_extensions.dart';
import '../../../theme/salmon_colors.dart';
import 'onboarding_page.dart';

class OnboardingPage3 extends HookWidget {
  const OnboardingPage3({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = useAnimationController(
      duration: const Duration(),
    );

    return OnboardingPage(
      header: Lottie.asset(
        SalmonAnims.handshake,
        height: context.mq.size.height * 0.35,
        reverse: true,
        controller: controller,
        onLoaded: (comp) {
          controller
            ..duration = comp.duration
            ..repeat(
              min: 0.3,
              max: 0.7,
            );
        },
        filterQuality: FilterQuality.medium,
        frameRate: FrameRate.composition,
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Our Promise', // TODO tr
            style: context.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Empowering Citizens, Embracing Transparency', // TODO tr
            style: context.textTheme.headlineSmall,
          )
        ],
      ),
      color: Theme.of(context).colorScheme.primary,
    );
  }
}
