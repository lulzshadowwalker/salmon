part of './issue_submission_components.dart';

class IssueSubmissionStep1 extends ConsumerStatefulWidget {
  const IssueSubmissionStep1({super.key});

  @override
  ConsumerState<IssueSubmissionStep1> createState() =>
      _IssueSubmissionStep1State();
}

class _IssueSubmissionStep1State extends ConsumerState<IssueSubmissionStep1> {
  final _focusNode = FocusNode();
  final _formFieldKey = GlobalKey<FormFieldState>();

  @override
  Widget build(BuildContext context) {
    final pages = ref.watch(_pagesProvider);
    final currentStep = ref.watch(_currentStepProvider);
    final submission = ref.watch(_submissionProvider);

    return Scaffold(
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
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          _focusNode.hasFocus
              ? FocusManager.instance.primaryFocus?.unfocus()
              : _focusNode.requestFocus();
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'How can we help you', // TODO tr
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
                      'Please provide a brief summary of the issue you are facing. This will help us understand and address your problem more efficiently', // TODO tr
                      speed: const Duration(milliseconds: 24),
                    ),
                  ],
                ),
              ),
              SalmonFormField(
                formFieldKey: _formFieldKey,
                focusNode: _focusNode,
                hintText: 'Summarize your problem ..', // TODO tr
                initialValue: submission.summary,
                maxLines: null,
                border: InputBorder.none,
                validator: (value) => value.isEmpty
                    ? 'Please give us a summary of your problem' // TODO tr
                    : null,
                onSaved: (value) {
                  ref.read(_submissionProvider.notifier).state =
                      submission.copyWith(
                    summary: value,
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
