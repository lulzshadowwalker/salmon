import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:salmon/views/shared/salmon_loading_indicator/salmon_loading_indicator.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

class SalmonAttachmentCard extends HookWidget {
  const SalmonAttachmentCard({
    required this.title,
    required this.child,
    required this.backgroundColor,
    this.size,
    this.onTap,
    this.hasValue = false,
    super.key,
  });

  static const _bounceDuration = Duration(milliseconds: 80);
  static final _borderRadius = BorderRadius.circular(10);

  final String title;
  final Widget child;
  final Color backgroundColor;
  final Function? onTap;
  final double? size;
  final bool hasValue;

  @override
  Widget build(BuildContext context) {
    final isLoading = useState(false);
    final isMounted = useIsMounted();

    final controller = useAnimationController(
      initialValue: 1,
      duration: const Duration(milliseconds: 1400),
    );

    final animation = Tween<double>(begin: -0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeOutQuad,
      ),
    );

    final waveHeight = useAnimation(animation);

    useEffect(() {
      hasValue ? controller.reverse() : controller.forward();
      return null;
    }, [hasValue]);

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 150),
      child: isLoading.value
          ? ColorFiltered(
              colorFilter: ColorFilter.mode(
                backgroundColor,
                BlendMode.srcIn,
              ),
              child: const SalmonLoadingIndicator(
                size: 64,
              ),
            )
          : SizedBox(
              height: size,
              child: AspectRatio(
                aspectRatio: 1,
                child: Bounceable(
                  onTap: () {},
                  duration: _bounceDuration,
                  reverseDuration: _bounceDuration,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      InkWell(
                        onTap: () async {
                          if (onTap == null) return;

                          isLoading.value = true;
                          await onTap!();

                          if (isMounted()) isLoading.value = false;
                        },
                        borderRadius: _borderRadius,
                        child: Container(
                          width: size,
                          decoration: BoxDecoration(
                            color: backgroundColor.withOpacity(0.2),
                            borderRadius: _borderRadius,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FractionallySizedBox(
                                widthFactor: 1,
                                child: Align(
                                  alignment: Alignment.center,
                                  child: child,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                title,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: HSLColor.fromColor(
                                    backgroundColor.withOpacity(0.75),
                                  ).withLightness(0.5).toColor(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      IgnorePointer(
                        child: Container(
                          width: size,
                          height: size,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          decoration: BoxDecoration(
                            borderRadius: _borderRadius,
                          ),
                          child: WaveWidget(
                            config: CustomConfig(
                              colors: [backgroundColor.withOpacity(0.4)],
                              durations: [5000],
                              heightPercentages: [waveHeight],
                            ),
                            size: Size(
                              size ?? double.infinity,
                              size ?? double.infinity,
                            ),
                            waveAmplitude: 0,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
