import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:salmon/controllers/notif/notif_controller.dart';
import 'package:salmon/helpers/salmon_const.dart';
import 'package:salmon/helpers/salmon_extensions.dart';
import 'package:salmon/providers/theme_data/theme_data_provider.dart';
import 'package:salmon/router/salmon_routes.dart';
import 'package:salmon/theme/salmon_colors.dart';
import 'package:salmon/views/onboarding/components/onboarding_page_1.dart';
import 'package:salmon/views/onboarding/components/onboarding_page_2.dart';
import 'package:salmon/views/onboarding/components/onboarding_page_3.dart';
import 'package:salmon/views/shared/salmon_loading_indicator/salmon_loading_indicator.dart';

class Onboarding extends HookConsumerWidget {
  const Onboarding({super.key});

  static const _pages = [
    OnboardingPage1(),
    OnboardingPage2(),
    OnboardingPage3(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(salmonThemeProvider);
    final currentPage = useState(0);
    final isLast = currentPage.value == _pages.length - 1;
    final isLoading = useState(false);
    final isMounted = useIsMounted();

    return Theme(
      data: theme.dark(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            body: Stack(
              children: [
                LiquidSwipe(
                  enableLoop: false,
                  ignoreUserGestureWhileAnimating: true,
                  enableSideReveal: true,
                  waveType: WaveType.circularReveal,
                  pages: _pages,
                  onPageChangeCallback: (activePage) =>
                      currentPage.value = activePage,
                ),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: isLast
                      ? Align(
                          alignment: Alignment.bottomCenter,
                          child: SafeArea(
                            child: Padding(
                              padding: const EdgeInsets.all(24),
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 250),
                                child: isLoading.value
                                    ? const ColorFiltered(
                                        colorFilter: ColorFilter.mode(
                                          SalmonColors.blue,
                                          BlendMode.srcIn,
                                        ),
                                        child: SalmonLoadingIndicator(),
                                      )
                                    : ElevatedButton(
                                        style: context
                                            .theme.elevatedButtonTheme.style
                                            ?.copyWith(
                                          backgroundColor: MaterialStateProperty
                                              .resolveWith<Color?>(
                                            (_) => SalmonColors.lightBlue,
                                          ),
                                        ),
                                        onPressed: () async {
                                          isLoading.value = true;

                                          await GetStorage().write(
                                              SalmonConst.skIsFirstLaunch,
                                              false);

                                          context.goNamed(SalmonRoutes.home);
                                          NotifController.init();
                                          if (isMounted()) {
                                            isLoading.value = false;
                                          }
                                        },
                                        child: const Text(
                                          'Continue to Salmon', // TODO tr
                                        ),
                                      ),
                              ),
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
