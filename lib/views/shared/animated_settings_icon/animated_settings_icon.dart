import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lottie/lottie.dart';
import 'package:salmon/helpers/salmon_anims.dart';
import 'package:salmon/theme/salmon_colors.dart';

class AnimatedSettingsIcon extends HookWidget {
  const AnimatedSettingsIcon({
    required this.isActive,
    this.inactiveColor,
    this.scale = 1,
    this.size = 36,
    super.key,
  });

  final bool isActive;
  final double size;
  final double scale;
  final Color? inactiveColor;

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
        con
          ..reset()
          ..repeat();
      } else {
        con.reverse();
      }

      return null;
    }, [isActive, isLoaded.value]);

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
          SalmonAnims.cog,
          height: size,
          controller: anim,
          onLoaded: (comp) {
            con.duration = comp.duration;
            isLoaded.value = true;
          },
          addRepaintBoundary: true,
        ),
      ),
    );
  }
}
