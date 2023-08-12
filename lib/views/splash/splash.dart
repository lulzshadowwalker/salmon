import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:salmon/helpers/salmon_anims.dart';
import 'package:salmon/helpers/salmon_extensions.dart';
import 'package:salmon/router/salmon_routes.dart';

import '../../theme/salmon_colors.dart';

class Splash extends HookWidget {
  const Splash({super.key});

  static final min = 105.normalized(maxVal: 360);
  static final max = 180.normalized(maxVal: 360);

  static void coolFunction(BuildContext context) async {
    context.goNamed(SalmonRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    final controller = useAnimationController(
      duration: const Duration(),
      lowerBound: min,
      upperBound: max,
    );

    useEffect(() {
      controller.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          coolFunction(context);
        }
      });

      return null;
    }, const []);

    final anim = CurvedAnimation(
      parent: controller,
      curve: Curves.ease,
    );

    return Scaffold(
      backgroundColor: SalmonColors.blue,
      body: Center(
        child: Lottie.asset(
          SalmonAnims.logo,
          controller: anim,
          onLoaded: (comp) {
            controller.duration = comp.duration * (max - min);
            controller.forward();
          },
          filterQuality: FilterQuality.high,
          frameRate: FrameRate.max,
        ),
      ),
    );
  }
}
