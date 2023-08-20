import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:salmon/helpers/salmon_anims.dart';
import 'package:salmon/providers/db/remote_db/remote_db_provider.dart';
import 'package:salmon/providers/theme_mode/theme_mode_provider.dart';
import 'package:salmon/providers/user_clap_count/user_clap_count_provider.dart';
import 'package:salmon/views/feed/components/post_data.dart';

import '../../../theme/salmon_colors.dart';

class ClapButton extends StatefulHookConsumerWidget {
  const ClapButton({super.key});

  @override
  ConsumerState<ClapButton> createState() => ClapButtonState();
}

class ClapButtonState extends ConsumerState<ClapButton> {
  static const _duration = Duration(milliseconds: 250);
  final _timeout = const Duration(milliseconds: 1100);
  late DateTime time;
  static const maxCount = 10;
  late int secondaryCounter;

  @override
  Widget build(BuildContext context) {
    final post = PostData.of(context)!.data;
    final counter = useState(0);
    final isVisible = useState(false);
    final isMounted = useIsMounted();
    final isMax = counter.value >= maxCount;
    final splashController = useAnimationController(duration: const Duration());
    final confettiController =
        useAnimationController(duration: const Duration());
    final isLight = ref.watch(themeModeProvider) == ThemeMode.light;
    final userClapCount = ref.watch(userClapCountProvider(post.id ?? ''));
    final isSplashLoaded = useState(false);

    useEffect(() {
      secondaryCounter = counter.value;
      void listener() {
        if (isMax || !isSplashLoaded.value) return;

        splashController
          ..reset()
          ..forward();
      }

      counter.addListener(listener);

      return () => counter.removeListener(listener);
    }, const []);

    useEffect(() {
      counter.value = userClapCount.value ?? 0;
      secondaryCounter = counter.value;
      return null;
    }, [userClapCount]);

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 280),
      child: userClapCount.hasValue
          ? WillPopScope(
              onWillPop: () async {
                if (userClapCount.value != counter.value) {
                  ref.read(remoteDbProvider).clap(post, counter.value);
                }
                return true;
              },
              child: Bounceable(
                duration: const Duration(milliseconds: 30),
                reverseDuration: const Duration(milliseconds: 30),
                scaleFactor: 0.75,
                onTap: () {},
                child: FloatingActionButton(
                  onPressed: () {
                    isVisible.value = true;
                    secondaryCounter++;
                    if (counter.value < maxCount) {
                      counter.value++;
                    }

                    time = DateTime.now();
                    Future.delayed(_timeout, () async {
                      if (!isMounted()) return;

                      if (time.add(_timeout).compareTo(DateTime.now()) <= 0) {
                        isVisible.value = false;
                      }
                    });
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      AnimatedSlide(
                        offset: isVisible.value
                            ? const Offset(0.0, -2.5)
                            : const Offset(0, 0),
                        curve: Curves.easeOutCubic,
                        duration: _duration * 2,
                        child: AnimatedScale(
                          scale: isVisible.value ? 1 : 0,
                          curve: Curves.easeOutCubic,
                          duration: _duration,
                          child: AnimatedOpacity(
                            opacity: isVisible.value ? 1 : 0,
                            curve: Curves.easeOutCubic,
                            duration: _duration,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Transform.scale(
                                  scale: isMax ? 5 : 7,
                                  child: ColorFiltered(
                                    colorFilter: ColorFilter.mode(
                                      isLight
                                          ? SalmonColors.black
                                          : SalmonColors.white,
                                      isMax ? BlendMode.dstIn : BlendMode.srcIn,
                                    ),
                                    child: isMax
                                        ? Lottie.asset(
                                            SalmonAnims.confetti,
                                            controller: confettiController,
                                            onLoaded: (comp) {
                                              confettiController.duration =
                                                  comp.duration;
                                              confettiController.forward();
                                            },
                                            height: 32,
                                            frameRate: FrameRate.composition,
                                            filterQuality: FilterQuality.low,
                                          )
                                        : Lottie.asset(
                                            SalmonAnims.splash,
                                            controller: splashController,
                                            frameRate: FrameRate.max,
                                            onLoaded: (comp) {
                                              splashController.duration =
                                                  comp.duration;
                                              isSplashLoaded.value = true;
                                            },
                                            height: 32,
                                          ),
                                  ),
                                ),
                                AnimatedContainer(
                                  duration: _duration,
                                  alignment: Alignment.center,
                                  height: 30,
                                  width: 30,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: secondaryCounter > maxCount
                                        ? SalmonColors.red
                                        : isLight
                                            ? SalmonColors.black
                                            : SalmonColors.white,
                                  ),
                                  child: Text(
                                    '${counter.value}',
                                    style: TextStyle(
                                      color: SalmonColors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const FaIcon(FontAwesomeIcons.handsClapping),
                    ],
                  ),
                ),
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}
