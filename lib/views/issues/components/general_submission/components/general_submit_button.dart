// ignore_for_file: use_build_context_synchronously

part of 'general_submission_components.dart';

final _isSubmittingProvider = StateProvider((ref) => false);

class _SubmitButton extends HookConsumerWidget {
  const _SubmitButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(_isSubmittingProvider);

    return FloatingActionButton.extended(
      onPressed: () async {
        if (isLoading) return;
        ref.read(_isSubmittingProvider.notifier).state = true;

        await Future.delayed(const Duration(seconds: 5));
        final submission = ref.read(_submissionProvider);

        await ref.read(submissionsControllerProvider).submit(
              context: context,
              submission: submission.copyWith(type: 'general'),
            );

        ref.read(_isSubmittingProvider.notifier).state = false;
        context.pop();
      },
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 450),
        child: isLoading
            ? const Padding(
                padding: EdgeInsetsDirectional.only(end: 8),
                child: SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    color: SalmonColors.black,
                    strokeWidth: 6,
                  ),
                ),
              )
            : Transform.flip(
                flipX: context.directionality == TextDirection.rtl,
                child: const FaIcon(FontAwesomeIcons.share),
              ),
      ),
      label: AnimatedSwitcher(
        duration: const Duration(milliseconds: 550),
        child:
            isLoading ? Text(context.sl.submitting) : Text(context.sl.submit),
      ),
    );
  }
}
