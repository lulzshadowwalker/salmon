part of './issue_submission_components.dart';

class IssueSubmissionStep2 extends HookConsumerWidget {
  const IssueSubmissionStep2({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final agencies = ref.watch(agenciesProvider);
    final pages = ref.watch(_pagesProvider);
    final currentStep = ref.watch(_currentStepProvider);
    final showRequired = useState(false);
    final submission = ref.watch(_submissionProvider);

    return SalmonUnfocusableWrapper(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (submission.agency == null) {
              showRequired.value = true;
              return;
            }

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
              Text(
                'To which agency is your issue related', // TODO tr
                style: context.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 48,
                child: AnimatedTextKit(
                  isRepeatingAnimation: false,
                  animatedTexts: [
                    TyperAnimatedText(
                      'select the relevant agency for your issue to receive personalized support',
                      speed: const Duration(milliseconds: 24),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              agencies.when(
                data: (data) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DropdownButton(
                        borderRadius: BorderRadius.circular(10),
                        underline: const SizedBox.shrink(),
                        dropdownColor: context.theme.scaffoldBackgroundColor,
                        elevation: 4,
                        hint: const Text('agency'), // TODO tr
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
                                          placeholder: (context, url) =>
                                              const SalmonLoadingIndicator(),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Text(
                                        e.enName ?? 'unknown',
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ), // TODO tr
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
                      const SizedBox(height: 8),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 250),
                        child: showRequired.value
                            ? Text(
                                'Please tell us the agency that you\'re facing an issue with', // TODO tr
                                style: context.textTheme.labelMedium?.copyWith(
                                  color: context.theme.colorScheme.error,
                                ),
                              )
                            : const SizedBox.shrink(),
                      ),
                    ],
                  );
                },
                error: (error, stackTrace) => const Center(
                  child: Text(
                    'Unknown error', // TODO SalmonError
                  ),
                ),
                loading: () => const Align(
                  alignment: Alignment.topCenter,
                  child: SalmonLoadingIndicator(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
