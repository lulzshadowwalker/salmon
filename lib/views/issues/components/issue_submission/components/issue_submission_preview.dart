part of './issue_submission_components.dart';

class _SubmissionPreview extends HookConsumerWidget {
  const _SubmissionPreview();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final submission = ref.watch(_submissionProvider);
    final isSubmitting = ref.watch(_isSubmittingProvider);
    final summaryController =
        useTextEditingController(text: submission.summary!);
    final detailsController =
        useTextEditingController(text: submission.details!);

    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();

        if (isSubmitting) {
          NotifsController.showPopup(
            context: context,
            title: context.sl.sendingIssue,
            message: context.sl.submittingIssue,
            type: NotifType.tip,
          );

          return;
        }
      },
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
                    final agencies = ref.watch(agenciesProvider(context.sl.localeName));

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
                                          imageUrl: e.logo ??
                                              SalmonImages.agencyPlacholder,
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
                        onChanged: isSubmitting
                            ? null
                            : (String? value) {
                                ref.read(_submissionProvider.notifier).set(
                                      submission.copyWith(
                                        agency: value,
                                      ),
                                    );
                              },
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
                    context.sl.summary,
                    style: context.textTheme.headlineSmall,
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: TextField(
                    enabled: !isSubmitting,
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
                    enabled: !isSubmitting,
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
                      padding: const EdgeInsetsDirectional.only(start: 14),
                      scrollDirection: Axis.horizontal,
                      children: [
                        ...List.generate(
                          (submission.attachments ?? []).length,
                          (index) {
                            final item =
                                submission.attachments![index] as XFile;

                            return Padding(
                              padding:
                                  const EdgeInsetsDirectional.only(end: 14),
                              child: Stack(
                                children: [
                                  AspectRatio(
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

                                          switch (mime.substring(
                                              0, mimeNameIndexEnd)) {
                                            case 'image':
                                              return SalmonFullscreenable(
                                                child: AspectRatio(
                                                  aspectRatio: 1,
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
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
                                                padding:
                                                    const EdgeInsets.all(8),
                                                color: SalmonColors.lightBlue,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    const FractionallySizedBox(
                                                      widthFactor: 1,
                                                      child: Align(
                                                        alignment:
                                                            Alignment.center,
                                                        child: FaIcon(
                                                          FontAwesomeIcons
                                                              .solidFile,
                                                          color:
                                                              SalmonColors.blue,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 16),
                                                    Text(
                                                      item.name,
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                        fontSize: 12,
                                                        color:
                                                            SalmonColors.blue,
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
                                      duration:
                                          const Duration(milliseconds: 30),
                                      reverseDuration:
                                          const Duration(milliseconds: 30),
                                      scaleFactor: 0.7,
                                      onTap: () {
                                        if (isSubmitting) return;

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
                              ),
                            );
                          },
                        ),
                        Stack(
                          children: [
                            AspectRatio(
                              aspectRatio: 1,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  margin:
                                      const EdgeInsetsDirectional.only(end: 14),
                                  color: SalmonColors.green.withOpacity(0.2),
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
                                      .removeLocation();
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
                        )
                      ],
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
