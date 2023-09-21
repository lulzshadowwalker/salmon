// ignore_for_file: use_build_context_synchronously

import 'package:concentric_transition/page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:salmon/helpers/salmon_const.dart';
import 'package:salmon/providers/notifs_controller/notifs_controller_provider.dart';
import 'package:salmon/providers/theme_data/theme_data_provider.dart';
import 'package:salmon/router/salmon_routes.dart';
import 'package:salmon/theme/salmon_colors.dart';
import 'package:salmon/views/onboarding/components/onboarding_page_1.dart';
import 'package:salmon/views/onboarding/components/onboarding_page_2.dart';
import 'package:salmon/views/onboarding/components/onboarding_page_3.dart';

class Onboarding extends HookConsumerWidget {
  const Onboarding({super.key});

  static final _pages = [
    const OnboardingPage1(),
    const OnboardingPage2(),
    const OnboardingPage3(),
  ];

  static final List<Color> _colors = [
    SalmonColors.blue,
    SalmonColors.yellow,
    SalmonColors.blue,
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(salmonThemeProvider);
    final currentPage = useState(0);
    final isLast = currentPage.value == _pages.length - 1;
    final isLoading = useState(false);
    final isMounted = useIsMounted();

    return Theme(
      data: theme.dark().copyWith(
            textTheme: theme.dark().textTheme.apply(
                  fontFamily: GoogleFonts.beVietnamPro().fontFamily,
                ),
          ),
      child: Builder(
        builder: (context) {
          return Scaffold(
            body: ConcentricPageView(
              colors: _colors,
              itemCount: _pages.length,
              onChange: (page) => currentPage.value = page,
              physics: const NeverScrollableScrollPhysics(),
              nextButtonBuilder: (context) => Icon(
                isLast ? FontAwesomeIcons.play : FontAwesomeIcons.angleRight,
                size: 32,
                color: isLast ? SalmonColors.yellow : SalmonColors.white,
              ),
              itemBuilder: (int index) => Center(
                child: _pages[index],
              ),
              radius: 50,
              onFinish: () async {
                await GetStorage().write(
                  SalmonConst.skIsFirstLaunch,
                  false,
                );

                context.goNamed(SalmonRoutes.home);
                ref.read(notifsControllerProvider).init();
                PhotoManager.requestPermissionExtend();
                if (isMounted()) {
                  isLoading.value = false;
                }
              },
            ),
          );
        },
      ),
    );
  }
}
