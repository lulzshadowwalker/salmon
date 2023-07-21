part of './components/issue_submission_components.dart';

final _pagesProvider = Provider.autoDispose<List<Widget>>((ref) {
  return const [
    IssueSubmissionStep1(),
    IssueSubmissionStep2(),
    IssueSubmissionStep3(),
    IssueSubmissionStep4(),
  ];
});

final _currentStepProvider = StateProvider.autoDispose<int>((ref) => 0);

final _submissionProvider =
    StateProvider.autoDispose<Submission>((ref) => const Submission());

class IssueSubmission extends ConsumerWidget {
  const IssueSubmission({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pages = ref.watch(_pagesProvider);
    final currentStep = ref.watch(_currentStepProvider);

    return SafeArea(
      child: Column(
        children: [
          Row(
            children: [
              BackButton(
                onPressed: () {
                  if (currentStep == 0) {
                    Navigator.of(context).pop();
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
                  child: StepProgressIndicator(
                    totalSteps: pages.length,
                    currentStep: currentStep + 1,
                    padding: 1,
                    selectedColor: SalmonColors.brown,
                    unselectedColor: SalmonColors.mutedLight,
                    roundedEdges: const Radius.circular(10),
                    size: 16,
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
    );
  }
}
