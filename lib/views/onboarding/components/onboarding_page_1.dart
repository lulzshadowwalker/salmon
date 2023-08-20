import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:salmon/helpers/salmon_anims.dart';
import 'package:salmon/helpers/salmon_extensions.dart';
import '../../../theme/salmon_colors.dart';
import 'onboarding_page.dart';

class OnboardingPage1 extends ConsumerWidget {
  const OnboardingPage1({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return OnboardingPage(
      header: Lottie.asset(
        SalmonAnims.government,
        height: context.mq.size.height * 0.35,
        reverse: true,
        filterQuality: FilterQuality.medium,
        frameRate: FrameRate.composition,
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Building Trust\nBridging the Gap',
            style: context.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          FittedBox(
            child: Text(
              'Where Citizens Meet Government',
              style: context.textTheme.headlineSmall,
            ),
          )
        ],
      ),
      color: SalmonColors.blue,
    );
  }
}
