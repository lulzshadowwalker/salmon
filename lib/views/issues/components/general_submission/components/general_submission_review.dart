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
                const SizedBox(height: 28),
                Padding(
                  padding: const EdgeInsetsDirectional.only(
                    start: 24,
                  ),
                  child: Text(
                    '${context.sl.refNo}: ${submission.id?.split('-')[0]}',
                    style: TextStyle(
                      color: SalmonColors.muted,
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
                              imageUrl:
                                  data?.logo ?? SalmonImages.agencyPlacholder,
                              height: 28,
                              width: 28,
                              imageBuilder: (context, imageProvider) => Padding(
                                padding: const EdgeInsetsDirectional.only(
                                  end: 8,
                                ),
                                child: Image(
                                  image: imageProvider,
                                ),
                              ),
                              errorWidget: (context, url, error) =>
                                  const SizedBox.shrink(),
                            ),
                            Expanded(
                              child: Text(
                                (context.isEn ? data?.enName : data?.arName) ??
                                    context.sl.unknown,
                                style: TextStyle(
                                  color: SalmonColors.muted,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      error: (error, stackTrace) => const SalmonUnknownError(),
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
                if ((submission.attachments ?? []).isNotEmpty ||
                    submission.location != null) ...[
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
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsetsDirectional.only(start: 14),
                      children: [
                        ...List.generate(
                          (submission.attachments ?? []).length,
                          (index) {
                            final item =
                                submission.attachments![index] as Attachment;

                            return Padding(
                              padding:
                                  const EdgeInsetsDirectional.only(end: 14),
                              child: AspectRatio(
                                aspectRatio: 1,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Builder(
                                    builder: (context) {
                                      final mime = item.mimeType ?? '';
                                      final mimeNameIndexEnd =
                                          mime.indexOf('/');
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
                                                child: CachedNetworkImage(
                                                  imageUrl: item.url ??
                                                      SalmonImages.notFound,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          );
                                        case 'video':
                                          final controller = item.url != null
                                              ? VideoPlayerController
                                                  .networkUrl(
                                                  Uri.parse(item.url!),
                                                )
                                              : VideoPlayerController.asset(
                                                  SalmonVideos.noise,
                                                );

                                          return SalmonFullscreenable(
                                            fullscreen: SalmonVideoPlayer(
                                              controller,
                                              onInitialized: (con) => con
                                                ..play()
                                                ..setVolume(100),
                                            ),
                                            onWillPop: () async {
                                              controller.setVolume(0);
                                              return true;
                                            },
                                            child: SalmonVideoPlayer(
                                              controller,
                                              onInitialized: (con) => con
                                                ..play()
                                                ..setVolume(0),
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
                                                      FontAwesomeIcons
                                                          .solidFile,
                                                      color: SalmonColors.blue,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 16),
                                                Text(
                                                  item.name ??
                                                      context.sl.unknown,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
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
                            );
                          },
                        ),
                        if (submission.location != null)
                          AspectRatio(
                            aspectRatio: 1,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                color: SalmonColors.green.withOpacity(0.2),
                                margin:
                                    const EdgeInsetsDirectional.only(end: 14),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    FractionallySizedBox(
                                      widthFactor: 1,
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: FaIcon(
                                          FontAwesomeIcons.locationDot,
                                          color: SalmonColors.green,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      context.sl.location,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: SalmonColors.green,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                      ],
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
