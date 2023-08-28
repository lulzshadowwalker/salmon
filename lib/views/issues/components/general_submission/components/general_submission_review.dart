part of 'general_submission_components.dart';

class GeneralSubmissionReview extends HookConsumerWidget {
  const GeneralSubmissionReview({
    required this.submission,
    super.key,
  });

  final Submission submission;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SalmonUnfocusableWrapper(
      child: Scaffold(
        appBar: context.canAnyPop ? AppBar() : null,
        body: SafeArea(
          child: SalmonSingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.only(
                    start: 36,
                    top: 24,
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
                    final agency =
                        ref.watch(agencyProvider(submission.agency!));

                    return agency.when(
                      data: (data) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        child: Row(
                          children: [
                            CachedNetworkImage(
                              imageUrl: data?.logo ?? '',
                              height: 28,
                              width: 28,
                            ), // TODO placeholder
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                (context.isEn
                                        ? data?.enName
                                        : data?.arName) ??
                                    context.sl.unknown,
                                style: TextStyle(
                                  color: SalmonColors.muted,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      error: (error, stackTrace) => const Text(
                        'Unknown error', // TODO SalmonError
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
                    context.sl.message,
                    style: context.textTheme.headlineSmall,
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Text(
                    submission.summary!,
                    style: TextStyle(
                      color: SalmonColors.muted,
                    ),
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
                        final item =
                            submission.attachments![index] as Attachment;

                        return AspectRatio(
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

                                switch (mime.substring(0, mimeNameIndexEnd)) {
                                  case 'image':
                                    return SalmonFullscreenable(
                                      child: AspectRatio(
                                        aspectRatio: 1,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: CachedNetworkImage(
                                            imageUrl: item.url ??
                                                '', // TODO placeholder
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    );
                                  case 'video':
                                    final controller =
                                        VideoPlayerController.networkUrl(
                                      Uri.parse(
                                          item.url ?? ''), // TODO placeholder
                                    );

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
                                            item.name ?? context.sl.unknown,
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
                        );
                      },
                    ),
                  ),
                ],
                const SizedBox(height: 48),
                Padding(
                  padding: const EdgeInsetsDirectional.only(
                    start: 24,
                  ),
                  child: Text(
                    context.sl.status,
                    style: context.textTheme.headlineSmall,
                  ),
                ),
                const SizedBox(height: 16),
                const _SubmissionReviewStepper(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
