import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:salmon/helpers/salmon_anims.dart';
import 'package:salmon/helpers/salmon_extensions.dart';
import '../../../theme/salmon_colors.dart';
import 'onboarding_page.dart';

class OnboardingPage2 extends StatelessWidget {
  const OnboardingPage2({super.key});

  @override
  Widget build(BuildContext context) {
    return OnboardingPage(
      header: Lottie.asset(
        SalmonAnims.communication,
        height: context.mq.size.height * 0.35,
        filterQuality: FilterQuality.medium,
        frameRate: FrameRate.composition,
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.sl.weListenWeAct,
            style: context.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            context.sl.yourGovYourTrust,
            style: context.textTheme.headlineSmall,
          )
        ],
      ),
      color: SalmonColors.yellow,
    );
  }
}
