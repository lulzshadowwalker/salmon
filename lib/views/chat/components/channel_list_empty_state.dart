import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:salmon/helpers/salmon_extensions.dart';

import '../../../helpers/salmon_anims.dart';
import '../../../theme/salmon_colors.dart';


class ChannelListEmptyState extends StatelessWidget {
  const ChannelListEmptyState({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ColorFiltered(
            colorFilter: const ColorFilter.mode(
              SalmonColors.lightBlue,
              BlendMode.srcIn,
            ),
            child: Lottie.asset(
              SalmonAnims.chatBubble,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 48,
            child: AnimatedTextKit(
              isRepeatingAnimation: false,
              animatedTexts: [
                TyperAnimatedText(
                  context.sl.startByHavingYourFirstChat,
                  textAlign: TextAlign.center,
                  speed: const Duration(milliseconds: 36),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
