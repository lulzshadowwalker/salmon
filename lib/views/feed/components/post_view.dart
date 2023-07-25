import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:salmon/providers/is_light_theme/is_light_theme_provider.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../models/post.dart';
import '../../../theme/salmon_colors.dart';

final _loadingProgressProvider = StateProvider<int>((ref) => 0);

class PostView extends StatefulHookConsumerWidget {
  const PostView({
    required this.post,
    super.key,
  });

  final Post post;

  @override
  ConsumerState<PostView> createState() => _PostViewState();
}

class _PostViewState extends ConsumerState<PostView> {
  final _webViewController = WebViewController();

  @override
  Widget build(BuildContext context) {
    final isMounted = useIsMounted();
    final isLight = ref.watch(isLightThemeProvider);

    return Scaffold(
      appBar:
          Navigator.of(context).canPop() || context.canPop() ? AppBar() : null,
      floatingActionButton: const _FloatingActionButton(),
      body: Stack(
        alignment: Alignment.center,
        children: [
          WebViewWidget(
            controller: _webViewController
              ..setJavaScriptMode(JavaScriptMode.unrestricted)
              ..setBackgroundColor(Theme.of(context).scaffoldBackgroundColor)
              ..setNavigationDelegate(
                NavigationDelegate(
                  onProgress: (int progress) {
                    if (isMounted()) {
                      ref.read(_loadingProgressProvider.notifier).state =
                          progress;
                    }
                  },
                ),
              )
              ..enableZoom(false)
              ..loadRequest(
                Uri.parse(
                  'https://flutter.dev/',
                ),
              ),
          ),
          Consumer(
            builder: (context, ref, child) {
              final prog = ref.watch(_loadingProgressProvider);

              return prog <= 90
                  ? CircularStepProgressIndicator(
                      totalSteps: 100,
                      currentStep: prog,
                      selectedColor: SalmonColors.yellow,
                      unselectedColor: SalmonColors.muted,
                      width: 50,
                      height: 50,
                      roundedCap: (_, __) => true,
                    )
                  : const SizedBox.shrink();
            },
          )
        ],
      ),
    );
  }
}

class _FloatingActionButton extends StatefulHookWidget {
  const _FloatingActionButton();

  @override
  State<_FloatingActionButton> createState() => _FloatingActionButtonState();
}

class _FloatingActionButtonState extends State<_FloatingActionButton> {
  static const _duration = Duration(milliseconds: 250);
  final timeout = const Duration(milliseconds: 350);
  late DateTime time;

  @override
  Widget build(BuildContext context) {
    final counter = useState(0);
    final isVisible = useState(false);
    final isMounted = useIsMounted();

    return FloatingActionButton(
      backgroundColor: SalmonColors.yellow,
      onPressed: () {
        isVisible.value = true;
        if (counter.value + 1 <= 10) counter.value++;

        time = DateTime.now();
        Future.delayed(const Duration(milliseconds: 800), () {
          if (isMounted()) {
            if (time.add(timeout).compareTo(DateTime.now()) <= 0) {
              isVisible.value = false;
            }
          }
        });
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          /// TODO add lottie animation
          AnimatedSlide(
            offset:
                isVisible.value ? const Offset(0.0, -2.5) : const Offset(0, 0),
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
                child: Container(
                  alignment: Alignment.center,
                  height: 30,
                  width: 30,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: SalmonColors.black,
                  ),
                  child: Text(
                    '${counter.value}',
                    style: TextStyle(
                      color: SalmonColors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const FaIcon(
            FontAwesomeIcons.handsClapping,
            color: SalmonColors.black,
          ),
        ],
      ),
    );
  }
}
