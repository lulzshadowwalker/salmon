// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lottie/lottie.dart';
import 'package:salmon/helpers/salmon_anims.dart';

class SalmonStepProgressIndicator extends HookWidget {
  const SalmonStepProgressIndicator({
    required this.totalSteps,
    required this.currentStep,
    required this.activeColor,
    required this.inactiveColor,
    this.height = 18,
    super.key,
  });

  final int totalSteps;
  final int currentStep;
  final Color activeColor;
  final Color inactiveColor;
  final double height;

  @override
  Widget build(BuildContext context) {
    final controller = useAnimationController(
      duration: const Duration(milliseconds: 850),
    );
    final lottieController = useAnimationController(duration: const Duration());
    final isLottieLoaded = useState(false);

    final progress = currentStep / totalSteps;

    useEffect(() {
      if (progress > controller.value) {
        controller.animateTo(progress).then((_) {
          if (isLottieLoaded.value) {
            lottieController
              ..reset()
              ..forward();
          }
        });

        return;
      }
      controller.animateBack(progress);
      return null;
    }, [currentStep, totalSteps]);

    final widthFactor = useAnimation(controller);

    return SizedBox(
      width: double.infinity,
      height: height,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: inactiveColor,
              borderRadius: BorderRadius.circular(50),
            ),
          ),
          FractionallySizedBox(
            widthFactor: widthFactor,
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: activeColor,
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                    width: 48,
                    child: Transform.scale(
                      scale: 8,
                      origin: const Offset(-3.0, 0.0),
                      child: ColorFiltered(
                        colorFilter: ColorFilter.mode(
                          activeColor,
                          BlendMode.srcIn,
                        ),
                        child: Lottie.asset(SalmonAnims.splash,
                            controller: lottieController, onLoaded: (comp) {
                          lottieController.duration = comp.duration;
                          isLottieLoaded.value = true;
                        }),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
