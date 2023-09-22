part of './components/general_submission_components.dart';

final _pagesProvider = Provider.autoDispose<List<Widget>>((ref) {
  return const [
    IssueSubmissionStep1(),
    GeneralSubmissionStep2(),
    GeneralSubmissionStep3(),
    _SubmissionPreview(),
  ];
});

final _currentStepProvider = StateProvider.autoDispose<int>((ref) => 0);

class GeneralSubmission extends ConsumerWidget {
  const GeneralSubmission({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pages = ref.watch(_pagesProvider);
    final currentStep = ref.watch(_currentStepProvider);
    final isSubmitting = ref.watch(_isSubmittingProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                BackButton(
                  onPressed: () {
                    if (isSubmitting) {
                      NotifsController.showPopup(
                        context: context,
                        title: context.sl.sendingSuggestion,
                        message: context.sl.submittingSuggestion,
                        type: NotifType.tip,
                      );

                      return;
                    }

                    if (currentStep == 0) {
                      context.pop();
                      return;
                    }

                    ref.read(_currentStepProvider.notifier).state--;
                  },
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsetsDirectional.only(
                      start: !context.canAnyPop ? 24 : 0,
                      end: 24,
                    ),
                    child: SalmonStepProgressIndicator(
                      totalSteps: pages.length,
                      currentStep: currentStep + 1,
                      activeColor: SalmonColors.blue,
                      inactiveColor: SalmonColors.mutedLight,
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 36),
                child: pages[currentStep],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
