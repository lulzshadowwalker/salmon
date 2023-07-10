import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lottie/lottie.dart';
import 'package:salmon/helpers/salmon_anims.dart';
import 'package:salmon/helpers/salmon_extensions.dart';

import '../../../theme/salmon_colors.dart';

class EyeSlash extends HookWidget {
  const EyeSlash({
    required this.isObscure,
    this.size = 16,
    super.key,
  });

  final double size;
  final bool isObscure;

  @override
  Widget build(BuildContext context) {
    final con = useAnimationController(
      duration: const Duration(milliseconds: 850),
    );

    final anim = Tween<double>(
      begin: 14.normalized(maxVal: 60),
      end: 47.normalized(maxVal: 60),
    ).animate(
      CurvedAnimation(
        parent: con,
        curve: Curves.easeOutQuad,
      ),
    );

    useEffect(
      () {
        isObscure ? con.reverse() : con.forward();

        return null;
      },
      [isObscure],
    );

    return ColorFiltered(
      colorFilter: ColorFilter.mode(
        SalmonColors.yellow,
        BlendMode.difference,
      ),
      child: Lottie.asset(
        SalmonAnims.eyeSlash,
        frameRate: FrameRate.max,
        height: size,
        controller: anim,
      ),
    );
  }
}
