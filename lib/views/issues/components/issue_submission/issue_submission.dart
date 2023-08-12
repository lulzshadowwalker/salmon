part of './components/issue_submission_components.dart';

final _pagesProvider = Provider.autoDispose<List<Widget>>((ref) {
  return const [
    IssueSubmissionStep1(),
    IssueSubmissionStep2(),
    IssueSubmissionStep3(),
    IssueSubmissionStep4(),
    _SubmissionPreview(),
  ];
});

final _currentStepProvider = StateProvider.autoDispose<int>((ref) => 0);

class IssueSubmission extends ConsumerWidget {
  const IssueSubmission({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pages = ref.watch(_pagesProvider);
    final currentStep = ref.watch(_currentStepProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                BackButton(
                  onPressed: () {
                    if (currentStep == 0) {
                      context.pop();
                      return;
                    }

                    ref.read(_currentStepProvider.notifier).state--;
                  },
                ),

                // TODO implement custom animated stepper widget
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
