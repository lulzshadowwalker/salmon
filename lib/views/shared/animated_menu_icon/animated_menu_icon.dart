import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:salmon/helpers/salmon_anims.dart';
import 'package:salmon/helpers/salmon_extensions.dart';
import 'package:salmon/providers/drawer/drawer_provider.dart';
import 'package:salmon/providers/theme/theme_mode/async_theme_mode_provider.dart';
import 'package:salmon/theme/salmon_colors.dart';

class AnimatedMenuIcon extends HookConsumerWidget {
  const AnimatedMenuIcon({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode =
        ref.watch(asyncThemeModeProvider).asData?.value == ThemeMode.dark;

    final con = useAnimationController(
      duration: const Duration(milliseconds: 435),
      upperBound: 22.normalized(maxVal: 56),
    );
    final isActive = useState(false);

    useEffect(() {
      if (con.duration == const Duration()) return;

      isActive.value ? con.forward() : con.reverse();

      return null;
    }, [isActive.value]);

    return GestureDetector(
      onTap: () {
        isActive.value = !isActive.value;
        ref.read(drawerStateProvider.notifier).toggle();
      },
      child: ColorFiltered(
        colorFilter: ColorFilter.mode(
          isDarkMode ? SalmonColors.white : SalmonColors.black,
          BlendMode.srcIn,
        ),
        child: Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()..scale(2.0, 2.0),
          child: Lottie.asset(
            SalmonAnims.menu,
            controller: con,
          ),
        ),
      ),
    );
  }
}
