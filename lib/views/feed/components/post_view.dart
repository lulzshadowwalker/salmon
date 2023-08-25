import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:salmon/helpers/salmon_extensions.dart';
import 'package:salmon/providers/a12n/a12n_provider.dart';
import 'package:salmon/theme/salmon_theme.dart';
import 'package:salmon/views/feed/components/post_comments.dart';
import 'package:salmon/views/feed/components/post_data.dart';
import 'package:salmon/views/feed/components/post_notification_chip.dart';
import 'package:salmon/views/shared/salmon_single_child_scroll_view/salmon_single_child_scroll_view.dart';
import 'package:we_slide/we_slide.dart';
import '../../../l10n/l10n_imports.dart';
import '../../../models/post.dart';
import '../../../providers/agency/agency_provider.dart';
import '../../../theme/salmon_colors.dart';
import 'clap_button.dart';

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
  static const double _panelMinSize = 72;

  late final _slideController = WeSlideController();

  @override
  Widget build(BuildContext context) {
    final double panelMaxSize = MediaQuery.of(context).size.height * .8;
    final isPanelOpen = useState(false);
    final isGuest = ref.watch(a12nProvider).isGuest;

    useEffect(() {
      void listener() {
        isPanelOpen.value = _slideController.value;
      }

      _slideController.addListener(listener);

      return () => _slideController.removeListener(listener);
    }, const []);

    return PostData(
      data: widget.post,
      child: Scaffold(
        floatingActionButton: AnimatedSwitcher(
          duration: const Duration(milliseconds: 350),
          child: isGuest || isPanelOpen.value
              ? const SizedBox.shrink()
              : const ClapButton(),
        ),
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
            // TODO long ass back button with an arrow
            backgroundColor: context.theme.scaffoldBackgroundColor,
            actions: const [
              PostNotificationChip(),
            ],
          ),
          body: SalmonSingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Hero(
                    tag: widget.post.id!,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CachedNetworkImage(
                          imageUrl:
                              widget.post.coverImage ?? '', // TODO placeholder
                          width: double.infinity,
                          height: 280,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (widget.post.dateCreated != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Text(
                              DateFormat.yMMMMd(SL.of(context).localeName)
                                  .format(widget.post.dateCreated!),
                              style: context.textTheme.bodySmall,
                            ),
                          ),
                        Text(
                          widget.post.enTitle!,
                          style: context.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 18),
                        Consumer(
                          builder: (context, ref, child) {
                            final agency = ref
                                .watch(agencyProvider(widget.post.createdBy!));

                            return agency.when(
                              data: (data) => Row(
                                children: [
                                  CachedNetworkImage(
                                    imageUrl: data?.logo ?? '',
                                    height: 24,
                                    width: 24,
                                    imageBuilder: (context, imageProvider) =>
                                        Padding(
                                            padding: const EdgeInsetsDirectional
                                                .only(end: 8),
                                            child: Image(
                                              image: imageProvider,
                                            )),
                                    errorWidget: (context, url, error) =>
                                        const SizedBox.shrink(),
                                  ),

                                  Expanded(
                                    child: Text(
                                      data?.enName ?? 'unknown',
                                      style: TextStyle(
                                        color: SalmonColors.muted,
                                      ),
                                    ),
                                  ), // TODO tr
                                ],
                              ),
                              error: (error, stackTrace) =>
                                  const SizedBox.shrink(),
                              loading: () => const SizedBox.shrink(),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: MarkdownBody(
                      data: widget.post.enBody!.replaceAll('<br>', '\n'),
                      styleSheet: SalmonTheme.markdownStyleSheet(context),
                    ),
                  ),
                ],
              ),
            ),
          ),
          panelHeader: GestureDetector(
            onTap: () {
              _slideController.show();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 32),
              color: context.theme.scaffoldBackgroundColor,
              child: const Row(
                children: [
                  FaIcon(
                    FontAwesomeIcons.comments,
                    size: 14,
                  ),
                  SizedBox(width: 8),
                  Text('comments'),
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
