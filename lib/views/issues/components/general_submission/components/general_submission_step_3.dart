part of 'general_submission_components.dart';

final _hasMediaProvider = StateProvider.autoDispose<bool>((ref) => false);
final _hasPhotoProvider = StateProvider.autoDispose<bool>((ref) => false);
final _hasVideoProvider = StateProvider.autoDispose<bool>((ref) => false);
final _hasLocationProvider = StateProvider.autoDispose<bool>((ref) => false);
final _hasFilesProvider = StateProvider.autoDispose<bool>((ref) => false);

class GeneralSubmissionStep3 extends HookConsumerWidget {
  const GeneralSubmissionStep3({super.key});

  static const _cardSize = double.infinity;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pages = ref.watch(_pagesProvider);
    final currentStep = ref.watch(_currentStepProvider);
    final submission = ref.watch(_submissionProvider);

    return SalmonUnfocusableWrapper(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final nextStep = (currentStep + 1).clamp(0, pages.length - 1);
            if (currentStep == nextStep) return;

            ref.read(_currentStepProvider.notifier).state = nextStep;
          },
          child: Transform.flip(
            flipX: context.directionality == TextDirection.rtl,
            child: FaIcon(
              pages.length - 1 != currentStep
                  ? FontAwesomeIcons.angleRight
                  : FontAwesomeIcons.share,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                child: Consumer(
                  builder: (context, ref, child) {
                    return Text(
                      context.sl.anythingWantToShowUs,
                      style: context.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 36),
              Expanded(
                child: GridView(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: context.mq.size.width > 480 ? 4 : 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  children: [
                    Consumer(
                      builder: (context, ref, child) {
                        return SalmonAttachmentCard(
                          onTap: () async {
                            final images = await SalmonHelpers.pickImages();

                            if (images == null || images.isEmpty) return;

                            ref.read(_hasMediaProvider.notifier).state = true;

                            ref.read(_submissionProvider.notifier).set(
                                  submission.copyWith(
                                    attachments: [
                                      ...?submission.attachments,
                                      ...images,
                                    ],
                                  ),
                                );
                          },
                          hasValue: ref.watch(_hasMediaProvider),
                          title: context.sl.media,
                          backgroundColor: SalmonColors.blue,
                          size: _cardSize,
                          child: const FaIcon(
                            FontAwesomeIcons.solidImage,
                            color: SalmonColors.blue,
                          ),
                        );
                      },
                    ),
                    Consumer(
                      builder: (context, ref, child) {
                        return SalmonAttachmentCard(
                          onTap: () async {
                            final image =
                                await SalmonHelpers.pickImageFromGallery();

                            if (image == null) return;

                            ref.read(_hasPhotoProvider.notifier).state = true;

                            ref.read(_submissionProvider.notifier).set(
                                  submission.copyWith(
                                    attachments: [
                                      ...?submission.attachments,
                                      image,
                                    ],
                                  ),
                                );
                          },
                          hasValue: ref.watch(_hasPhotoProvider),
                          title: context.sl.photo,
                          backgroundColor: Colors.deepPurple,
                          size: _cardSize,
                          child: const FaIcon(
                            FontAwesomeIcons.camera,
                            color: Colors.deepPurple,
                          ),
                        );
                      },
                    ),
                    Consumer(
                      builder: (context, ref, child) {
                        return SalmonAttachmentCard(
                          onTap: () async {
                            final video =
                                await SalmonHelpers.pickVideoFromCamera();

                            if (video == null) return;

                            ref.read(_hasVideoProvider.notifier).state = true;

                            ref.read(_submissionProvider.notifier).set(
                                  submission.copyWith(
                                    attachments: [
                                      ...?submission.attachments,
                                      video,
                                    ],
                                  ),
                                );
                          },
                          hasValue: ref.watch(_hasVideoProvider),
                          title: context.sl.record,
                          backgroundColor: SalmonColors.orange,
                          size: _cardSize,
                          child: FaIcon(
                            FontAwesomeIcons.video,
                            color: SalmonColors.orange,
                          ),
                        );
                      },
                    ),
                    Consumer(
                      builder: (context, ref, child) {
                        return SalmonAttachmentCard(
                          onTap: () async {
                            final location = await Navigator.push<LatLng>(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const SalmonLocationPicker(),
                              ),
                            );

                            if (location == null) return;

                            ref.read(_hasLocationProvider.notifier).state =
                                true;

                            ref.read(_submissionProvider.notifier).set(
                                  submission.copyWith(
                                    location: () => GeoPoint(
                                      location.latitude,
                                      location.longitude,
                                    ),
                                  ),
                                );
                          },
                          hasValue: ref.watch(_hasLocationProvider),
                          title: context.sl.location,
                          backgroundColor: SalmonColors.green,
                          size: _cardSize,
                          child: FaIcon(
                            FontAwesomeIcons.locationDot,
                            color: SalmonColors.green,
                          ),
                        );
                      },
                    ),
                    Consumer(
                      builder: (context, ref, child) {
                        return SalmonAttachmentCard(
                          onTap: () async {
                            final files = await SalmonHelpers.pickFiles();

                            if (files == null || files.isEmpty) return;

                            ref.read(_hasFilesProvider.notifier).state = true;

                            ref.read(_submissionProvider.notifier).set(
                                  submission.copyWith(
                                    attachments: [
                                      ...?submission.attachments,
                                      ...files,
                                    ],
                                  ),
                                );
                          },
                          hasValue: ref.watch(_hasFilesProvider),
                          title: context.sl.files,
                          backgroundColor: SalmonColors.brown,
                          size: _cardSize,
                          child: const FaIcon(
                            FontAwesomeIcons.solidFile,
                            color: SalmonColors.brown,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
