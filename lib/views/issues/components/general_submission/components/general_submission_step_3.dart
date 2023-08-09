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
                      'Anything you want to show us', // TODO tr
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
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
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
                          title: 'media', // TODO tr
                          backgroundColor: SalmonColors.blue,
                          size: _cardSize,
                          child: const FaIcon(FontAwesomeIcons.solidImage),
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
                          title: 'photo', // TODO tr
                          backgroundColor: Colors.deepPurple,
                          size: _cardSize,
                          child: const FaIcon(FontAwesomeIcons.camera),
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
                          title: 'record', // TODO tr
                          backgroundColor: SalmonColors.orange,
                          size: _cardSize,
                          child: const FaIcon(FontAwesomeIcons.video),
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
                                    location: GeoPoint(
                                      location.latitude,
                                      location.longitude,
                                    ),
                                  ),
                                );
                          },
                          hasValue: ref.watch(_hasLocationProvider),
                          title: 'location', // TODO tr
                          backgroundColor: SalmonColors.green,
                          size: _cardSize,
                          child: const FaIcon(FontAwesomeIcons.locationDot),
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
                          title: 'files', // TODO tr
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          size: _cardSize,
                          child: const FaIcon(FontAwesomeIcons.solidFile),
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
