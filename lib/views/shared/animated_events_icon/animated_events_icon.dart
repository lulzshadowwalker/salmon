import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lottie/lottie.dart';
import 'package:salmon/theme/salmon_colors.dart';

import '../../../helpers/salmon_anims.dart';

class AnimatedEventsIcon extends HookWidget {
  const AnimatedEventsIcon({
    required this.isActive,
    this.scale = 1.2,
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
    final con = useAnimationController(
      duration: const Duration(milliseconds: 3000),
    );

    useEffect(() {
      if (isActive) {
        con.repeat(reverse: true);
      } else {
        con.value > con.lowerBound ? con.animateBack(0.5) : con.value = 0.5;
      }

      return null;
    }, [isActive]);

    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()..scale(scale, scale),
      child: ColorFiltered(
        colorFilter: ColorFilter.mode(
          isActive
              ? Theme.of(context).colorScheme.primary
              : inactiveColor ?? SalmonColors.mutedLight,
          BlendMode.srcIn,
        ),
        child: Lottie.asset(
          SalmonAnims.events,
          height: size,
          controller: con,
          addRepaintBoundary: true,
        ),
      ),
    );
  }
}
