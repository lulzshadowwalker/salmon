part of 'general_submission_components.dart';

class _SubmitButton extends HookConsumerWidget {
  const _SubmitButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = useState(false);
    final isMounted = useIsMounted();

    return FloatingActionButton(
      onPressed: () async {
        if (isLoading.value) return;

        isLoading.value = true;
        final submission = ref.read(_submissionProvider);

        await ref.read(submissionsControllerProvider).submit(
              context: context,
              submission: submission.copyWith(type: 'general'),
            );

        if (isMounted()) isLoading.value = false;

        context.pop();
      },
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 450),
        child: isLoading.value
            ? const Padding(
                padding: EdgeInsets.all(18.0),
                child: CircularProgressIndicator(
                  color: SalmonColors.black,
                  strokeWidth: 6,
                ),
              )
            : Transform.flip(
                flipX: context.directionality == TextDirection.rtl,
                child: const FaIcon(FontAwesomeIcons.share),
              ),
      ),
    );
  }
}
