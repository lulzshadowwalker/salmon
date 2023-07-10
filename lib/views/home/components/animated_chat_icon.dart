import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lottie/lottie.dart';
import 'package:salmon/helpers/salmon_extensions.dart';
import 'package:salmon/theme/salmon_colors.dart';

import '../../../helpers/salmon_anims.dart';

class AnimatedChatIcon extends HookWidget {
  const AnimatedChatIcon({
    required this.isActive,
    this.scale = 1,
    this.size = 36,
    super.key,
  });

  final bool isActive;
  final double size;
  final double scale;

  @override
  Widget build(BuildContext context) {
    final con = useAnimationController(duration: const Duration());
    final isLoaded = useState(false);

    final anim = CurvedAnimation(
      parent: con,
      curve: Curves.easeOut,
    );

    useEffect(() {
      if (con.duration == const Duration()) return;

      if (isActive) {
        con.animateTo(955.normalized(maxVal: 1800)).then(
              (_) => con.forward().then(
                    (_) => con.repeat(),
                  ),
            );
      } else {
        final target = 1000.normalized(maxVal: 1800);
        con.value == 0 ? con.value = target : con.animateTo(target);
      }

      return null;
    }, [isActive, isLoaded.value]);

    return ColorFiltered(
      colorFilter: ColorFilter.mode(
        isActive ? SalmonColors.yellow : SalmonColors.muted,
        BlendMode.srcIn,
      ),
      child: Transform(
        alignment: Alignment.center,
        transform: Matrix4.identity()..scale(scale, scale),
        child: Lottie.asset(
          SalmonAnims.chat,
          height: size,
          controller: anim,
          onLoaded: (comp) {
            con.duration = comp.duration + const Duration(milliseconds: 250);
            isLoaded.value = true;
          },
        ),
      ),
    );
  }
}
