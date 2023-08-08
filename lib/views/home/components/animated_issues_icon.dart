import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lottie/lottie.dart';

import '../../../helpers/salmon_anims.dart';
import '../../../theme/salmon_colors.dart';

class AnimatedIssuesIcon extends HookWidget {
  const AnimatedIssuesIcon({
    required this.isActive,
    this.scale = 1.0,
    this.size = 42,
    super.key,
  });

  final bool isActive;
  final double size;
  final double scale;

  @override
  Widget build(BuildContext context) {
    final con = useAnimationController(duration: const Duration(seconds: 1));
    final isLoaded = useState(false);

    useEffect(() {
      if (!isLoaded.value) return;

      isActive ? con.forward() : con.reverse();

      return null;
    }, [
      isLoaded.value,
      isActive,
    ]);

    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()..scale(scale, scale),
      child: AnimatedContainer(
        duration: con.duration!,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isActive ? SalmonColors.yellow : SalmonColors.lightYellow,
          borderRadius: BorderRadius.circular(15),
        ),
        child: ColorFiltered(
          colorFilter: const ColorFilter.mode(
            SalmonColors.black,
            BlendMode.srcIn,
          ),
          child: Lottie.asset(
            SalmonAnims.flag,
            height: size,
            controller: con,
            onLoaded: (comp) {
              con.duration = comp.duration + const Duration(milliseconds: 250);
              isLoaded.value = true;
            },
            filterQuality: FilterQuality.low,
            frameRate: FrameRate.max,
          ),
        ),
      ),
    );
  }
}
