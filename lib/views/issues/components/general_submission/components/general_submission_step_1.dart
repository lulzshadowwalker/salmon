part of './general_submission_components.dart';

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
                context.sl.tellUsWhatsOnYourMind,
                style: context.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 64,
                child: AnimatedTextKit(
                  isRepeatingAnimation: false,
                  animatedTexts: [
                    TyperAnimatedText(
                      context.sl.wouldLikeToHearWhatYouHave,
                      speed: const Duration(milliseconds: 24),
                    ),
                  ],
                ),
              ),
              SalmonFormField(
                formFieldKey: _formFieldKey,
                focusNode: _focusNode,
                hintText: context.sl.weAreListening,
                initialValue: submission.summary,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                border: InputBorder.none,
                validator: (value) =>
                    value.isEmpty ? context.sl.anythingYouHaveToSay : null,
                onSaved: (value) {
                  ref.read(_submissionProvider.notifier).set(
                        submission.copyWith(
                          summary: value?.trim(),
                        ),
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
