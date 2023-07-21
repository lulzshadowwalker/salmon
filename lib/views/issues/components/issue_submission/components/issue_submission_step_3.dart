part of './issue_submission_components.dart';

class IssueSubmissionStep3 extends ConsumerStatefulWidget {
  const IssueSubmissionStep3({super.key});

  @override
  ConsumerState<IssueSubmissionStep3> createState() =>
      _IssueSubmissionStep3State();
}

class _IssueSubmissionStep3State extends ConsumerState<IssueSubmissionStep3> {
  final _focusNode = FocusNode();
  final _formFieldKey = GlobalKey<FormFieldState>();

  @override
  Widget build(BuildContext context) {
    final pages = ref.watch(_pagesProvider);
    final currentStep = ref.watch(_currentStepProvider);
    final submission = ref.watch(_submissionProvider);

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        _focusNode.hasFocus
            ? FocusManager.instance.primaryFocus?.unfocus()
            : _focusNode.requestFocus();
      },
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (_formFieldKey.currentState == null ||
                !_formFieldKey.currentState!.validate()) return;

            _formFieldKey.currentState!.save();

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
                'Help us\nhelp you', // TODO tr
                style: context.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SalmonFormField(
                formFieldKey: _formFieldKey,

                focusNode: _focusNode,
                hintText: 'Tell us more about your problem', // TODO tr
                maxLines: null,
                border: InputBorder.none,
                validator: (value) => value.isEmpty
                    ? 'Please give us more details about your problem' // TODO tr
                    : null,
                onSaved: (value) {
                  ref.read(_submissionProvider.notifier).state =
                      submission.copyWith(
                    details: value,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
