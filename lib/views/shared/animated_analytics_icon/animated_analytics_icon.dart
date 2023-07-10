import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lottie/lottie.dart';
import 'package:salmon/theme/salmon_colors.dart';

import '../../../helpers/salmon_anims.dart';

class AnimatedAnalyticsIcon extends HookWidget {
  const AnimatedAnalyticsIcon({
    required this.isActive,
    this.scale = 1.7,
    this.size = 36,
    this.inactiveColor,
    super.key,
  });

  final bool isActive;
  final double size;
  final double scale;
  final Color? inactiveColor;

  @override
  Widget build(BuildContext context) {
    final con =
        useAnimationController(duration: const Duration(milliseconds: 2500));

    final anim = CurvedAnimation(
      parent: con,
      curve: Curves.easeOut,
    );

    useEffect(() {
      if (isActive) {
        con
          ..reset()
          ..repeat(reverse: true);
      } else {
        con.reverse();
      }

      return null;
    }, [isActive]);

    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()..scale(scale, scale),
      child: ColorFiltered(
        colorFilter: ColorFilter.mode(
          isActive
              ? SalmonColors.yellow
              : inactiveColor ?? SalmonColors.mutedLight,
          BlendMode.srcIn,
        ),
        child: Lottie.asset(
          SalmonAnims.analytics,
          height: size,
          controller: anim,
        ),
      ),
    );
  }
}
