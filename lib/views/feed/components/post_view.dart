import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:salmon/helpers/salmon_extensions.dart';
import 'package:salmon/helpers/salmon_helpers.dart';
import 'package:salmon/providers/a12n/a12n_provider.dart';
import 'package:salmon/views/feed/components/post_comments.dart';
import 'package:salmon/views/feed/components/post_data.dart';
import 'package:salmon/views/feed/components/post_notification_chip.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:we_slide/we_slide.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../models/post.dart';
import '../../../theme/salmon_colors.dart';
import 'clap_button.dart';

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
  late final _webViewController = WebViewController()
    ..loadHtmlString(widget.post.lightEnBody!);

  static const double _panelMinSize = 72;

  late final _slideController = WeSlideController();

  @override
  Widget build(BuildContext context) {
    final isMounted = useIsMounted();
    final double panelMaxSize = MediaQuery.of(context).size.height * .8;
    final isPanelOpen = useState(false);
    final isGuest = ref.watch(a12nProvider).isGuest;

    useEffect(() {
      void listener() {
        isPanelOpen.value = _slideController.isOpened;
      }

      _slideController.addListener(listener);

      return () => _slideController.removeListener(listener);
    }, const []);

    return PostData(
      data: widget.post,
      child: Scaffold(
        body: WeSlide(
          parallax: true,
          hideAppBar: true,
          panelMinSize: _panelMinSize,
          panelMaxSize: panelMaxSize,
          blurColor: SalmonColors.mutedLight,
          backgroundColor: Colors.transparent,
          overlayColor: Colors.transparent,
          blur: true,
          parallaxOffset: 0.9,
          appBarHeight: 120.0,
          controller: _slideController,
          appBar: AppBar(
            backgroundColor: context.theme.scaffoldBackgroundColor,
            actions: const [
              PostNotificationChip(),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: Container(
                  color: context.theme.scaffoldBackgroundColor,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Scaffold(
                        floatingActionButton: isGuest
                            ? const SizedBox.shrink()
                            : const ClapButton(),
                        body: WebViewWidget(
                          controller: _webViewController
                            ..setJavaScriptMode(JavaScriptMode.unrestricted)
                            // ..setBackgroundColor(
                            //     Theme.of(context).scaffoldBackgroundColor)
                            ..setNavigationDelegate(
                              NavigationDelegate(
                                onWebResourceError: (error) {
                                  SalmonHelpers.getLogger('PostView').e(error);
                                },
                                onProgress: (int progress) {
                                  if (isMounted()) {
                                    ref
                                        .read(_loadingProgressProvider.notifier)
                                        .state = progress;
                                  }
                                },
                              ),
                            )
                            ..enableZoom(false),
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
                ),
              ),
            ],
          ),
          panelHeader: GestureDetector(
            onTap: () {
              _slideController.show();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
              color: context.theme.scaffoldBackgroundColor,
              child: const Row(
                children: [
                  const FaIcon(FontAwesomeIcons.comments),
                  SizedBox(width: 12),
                  const Text('comments'),
                ],
              ),
            ),
          ),
          hidePanelHeader: true,
          panel: isPanelOpen.value
              ? const PostComments()
              : Container(
                  color: context.theme.scaffoldBackgroundColor,
                ),
        ),
      ),
    );
  }
}
