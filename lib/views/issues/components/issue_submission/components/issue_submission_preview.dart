part of './issue_submission_components.dart';

class _SubmissionPreview extends HookConsumerWidget {
  const _SubmissionPreview();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final submission = ref.watch(_submissionProvider);
    final summaryController =
        useTextEditingController(text: submission.summary!);
    final detailsController =
        useTextEditingController(text: submission.details!);

    return SalmonUnfocusableWrapper(
      child: Scaffold(
        floatingActionButton: const _SubmitButton(),
        body: SafeArea(
          child: SalmonSingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.only(
                    start: 36,
                  ),
                  child: Text(
                    context.sl.submissionReview.replaceAll(' ', '\n'),
                    style: context.textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 48),
                Padding(
                  padding: const EdgeInsetsDirectional.only(
                    start: 24,
                  ),
                  child: Text(
                    context.sl.agency,
                    style: context.textTheme.headlineSmall,
                  ),
                ),
                const SizedBox(height: 12),
                Consumer(
                  builder: (context, ref, child) {
                    final agencies = ref.watch(agenciesProvider);

                    return agencies.when(
                      data: (data) => DropdownButton(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        borderRadius: BorderRadius.circular(10),
                        underline: const SizedBox.shrink(),
                        dropdownColor: context.theme.scaffoldBackgroundColor,
                        elevation: 4,
                        hint: Text(context.sl.agency.toLowerCase()),
                        isExpanded: true,
                        value: submission.agency,
                        items: data
                            .map(
                              (e) => DropdownMenuItem(
                                value: e.id,
                                child: Row(
                                  children: [
                                    SizedBox(
                                      height: 24,
                                      width: 24,
                                      child: FittedBox(
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              e.logo ?? SalmonImages.notFound,
                                          imageBuilder:
                                              (context, imageProvider) =>
                                                  Padding(
                                            padding: const EdgeInsetsDirectional
                                                .only(
                                              end: 16,
                                            ),
                                            child: Image(
                                              image: imageProvider,
                                            ),
                                          ),
                                          placeholder: (context, url) =>
                                              const SizedBox.shrink(),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        (context.isEn ? e.enName : e.arName) ??
                                            context.sl.unknown,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: SalmonColors.muted,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          ref.read(_submissionProvider.notifier).set(
                                submission.copyWith(
                                  agency: value,
                                ),
                              );
                        },
                      ),
                      error: (error, stackTrace) => const Center(
                        child: Text(
                          'Unknown error', // TODO SalmonError
                        ),
                      ),
                      loading: () => const SalmonLoadingIndicator(),
                    );
                  },
                ),
                const SizedBox(height: 48),
                Padding(
                  padding: const EdgeInsetsDirectional.only(
                    start: 24,
                  ),
                  child: Text(
                    context.sl.summary,
                    style: context.textTheme.headlineSmall,
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: TextField(
                    controller: summaryController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      isCollapsed: true,
                    ),
                    style: TextStyle(
                      color: SalmonColors.muted,
                    ),
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    onChanged: (value) {
                      ref.read(_submissionProvider.notifier).set(
                            submission.copyWith(
                              summary: value.trim(),
                            ),
                          );
                    },
                  ),
                ),
                const SizedBox(height: 48),
                Padding(
                  padding: const EdgeInsetsDirectional.only(
                    start: 24,
                  ),
                  child: Text(
                    context.sl.details,
                    style: context.textTheme.headlineSmall,
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: TextField(
                    controller: detailsController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      isCollapsed: true,
                    ),
                    style: TextStyle(
                      color: SalmonColors.muted,
                    ),
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    onChanged: (value) {
                      ref.read(_submissionProvider.notifier).set(
                            submission.copyWith(
                              details: value.trim(),
                            ),
                          );
                    },
                  ),
                ),
                if ((submission.attachments ?? []).isNotEmpty) ...[
                  const SizedBox(height: 48),
                  Padding(
                    padding: const EdgeInsetsDirectional.only(
                      start: 24,
                    ),
                    child: Text(
                      context.sl.attachments,
                      style: context.textTheme.headlineSmall,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 128,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 12),
                      itemCount: (submission.attachments ?? []).length,
                      itemBuilder: (context, index) {
                        final item = submission.attachments![index] as XFile;

                        return Stack(
                          children: [
                            AspectRatio(
                              aspectRatio: 1,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Builder(
                                  builder: (context) {
                                    final mime = item.mimeType ?? '';
                                    final mimeNameIndexEnd = mime.indexOf('/');
                                    if (mimeNameIndexEnd == -1) {
                                      return const SizedBox.shrink();
                                    }

                                    switch (
                                        mime.substring(0, mimeNameIndexEnd)) {
                                      case 'image':
                                        return SalmonFullscreenable(
                                          child: AspectRatio(
                                            aspectRatio: 1,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: Image.file(
                                                File(item.path),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        );
                                      case 'video':
                                        final controller =
                                            VideoPlayerController.file(
                                                File(item.path));

                                        return SalmonFullscreenable(
                                          child: SalmonVideoPlayer(
                                            controller,
                                            onInitialized: (con) => con.play(),
                                          ),
                                        );
                                      default:
                                        return Container(
                                          padding: const EdgeInsets.all(8),
                                          color: SalmonColors.lightBlue,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const FractionallySizedBox(
                                                widthFactor: 1,
                                                child: Align(
                                                  alignment: Alignment.center,
                                                  child: FaIcon(
                                                    FontAwesomeIcons.solidFile,
                                                    color: SalmonColors.blue,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 16),
                                              Text(
                                                item.name,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  color: SalmonColors.blue,
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                    }
                                  },
                                ),
                              ),
                            ),
                            Positioned(
                              top: 4,
                              right: 4,
                              child: Bounceable(
                                duration: const Duration(milliseconds: 30),
                                reverseDuration:
                                    const Duration(milliseconds: 30),
                                scaleFactor: 0.7,
                                onTap: () {
                                  ref
                                      .read(_submissionProvider.notifier)
                                      .removeAttachments(item);
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: Container(
                                    color: SalmonColors.white,
                                    child: Icon(
                                      Icons.remove_circle_rounded,
                                      color: SalmonColors.red,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
