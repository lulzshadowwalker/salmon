import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:salmon/theme/salmon_colors.dart';

import '../../../helpers/salmon_anims.dart';

class SalmonLoadingIndicator extends StatelessWidget {
  const SalmonLoadingIndicator({
    this.color = SalmonColors.blue,
    this.size,
    super.key,
  });

  final double? size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 5,
      child: ColorFiltered(
        colorFilter: ColorFilter.mode(
          color,
          BlendMode.srcIn,
        ),
        child: Lottie.asset(
          SalmonAnims.googleLoading,
          reverse: true,
          frameRate: FrameRate.max,
          filterQuality: FilterQuality.high,
          height: size ?? 42,
        ),
      ),
    );
  }
}
