part of './issue_submission_components.dart';

class _SubmissionReviewStepper extends HookWidget {
  const _SubmissionReviewStepper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final activeStep = useMemoized(() => 0);

    return EasyStepper(
      activeStep: activeStep,
      activeStepBackgroundColor: context.cs.primary,
      finishedStepBackgroundColor: context.cs.primaryContainer,
      finishedStepTextColor: SalmonColors.muted,
      activeStepIconColor: SalmonColors.black,
      activeStepTextColor: SalmonColors.black,
      unreachedStepIconColor: SalmonColors.mutedLight,
      unreachedStepBackgroundColor: SalmonColors.mutedLight,
      unreachedStepTextColor: SalmonColors.muted,
      activeStepBorderColor: Colors.transparent,
      finishedStepBorderColor: Colors.transparent,
      unreachedStepBorderColor: Colors.transparent,
      enableStepTapping: false,
      stepBorderRadius: 5,
      steps: [
        EasyStep(
          customStep: const Icon(Icons.ac_unit),
          title: context.sl.submitted,
        ),
        EasyStep(
          customStep: const Icon(Icons.ac_unit),
          title: context.sl.underReview,
        ),
        EasyStep(
          customStep: const Icon(Icons.ac_unit),
          title: context.sl.resolved,
        ),
      ],
    );
  }
}
