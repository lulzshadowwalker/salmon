part of './issues_components.dart';

class _SubmissionTile extends HookWidget {
  const _SubmissionTile({
    this.index,
    required this.submission,
  });

  final int? index;
  final Submission submission;

  @override
  Widget build(BuildContext context) {
    final animate = useState(false);
    final future = useMemoized(
      () => Future.delayed(
          Duration(milliseconds: index == null ? 0 : 75 * (index! + 1)), () {
        animate.value = true;
      }),
    );

    useFuture(future);

    // TODO add lottie to animate on [animate] only forward

    return AnimatedScale(
      duration: const Duration(milliseconds: 80),
      scale: animate.value ? 1 : 0,
      curve: Curves.easeOutCubic,
      child: Bounceable(
        onTap: () {
          context.goNamed(
            SalmonRoutes.submissionReview,
            extra: submission,
          );
        },
        duration: const Duration(milliseconds: 80),
        reverseDuration: const Duration(milliseconds: 80),
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          decoration: BoxDecoration(
            color: SalmonColors.mutedLight.withOpacity(0.6),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            children: [
              Transform.flip(
                flipX: true,
                child: const FaIcon(
                  FontAwesomeIcons.clockRotateLeft,
                  size: 22,
                  color: SalmonColors.black,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  submission.summary ?? 'unknown', // TODO tr
                  maxLines: 1,
                  style: const TextStyle(
                    color: SalmonColors.black,
                  ),
                ),
              ),
              FaIcon(
                context.directionality == TextDirection.ltr
                    ? FontAwesomeIcons.angleRight
                    : FontAwesomeIcons.angleLeft,
                color: context.cs.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
