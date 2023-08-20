part of './components/salmon_poll_components.dart';

class SalmonPoll extends HookConsumerWidget {
  const SalmonPoll({
    required this.poll,
    super.key,
  });

  final Poll poll;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PollData(
      data: poll,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Commnuity Question', // TODO tr
            style: TextStyle(
              color: SalmonColors.muted,
            ),
          ),
          Consumer(
            builder: (context, ref, child) {
              final agency = ref.watch(agencyProvider(poll.createdBy ?? ''));

              return agency.when(
                data: (data) => Row(
                  children: [
                    CachedNetworkImage(
                      imageUrl: data?.logo ?? '',
                      imageBuilder: (context, img) => Padding(
                          padding: const EdgeInsetsDirectional.only(end: 6),
                          child: Image(image: img)),
                      errorWidget: (context, url, error) =>
                          const SizedBox.shrink(),
                      height: 24,
                      width: 24,
                    ),
                    Expanded(
                      child: Text(
                        data?.enName ?? 'unknown',
                        style: context.textTheme.labelMedium?.copyWith(
                          color: SalmonColors.muted,
                        ),
                      ),
                    ), // TODO tr
                  ],
                ),
                error: (_, __) => const SizedBox.shrink(),
                loading: () => const SizedBox.shrink(),
              );
            },
          ),
          const SizedBox(height: 8),
          Text(
            poll.enTitle ?? 'unknown', // TODO tr
            style: context.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...List.generate(
            (poll.options ?? []).length,
            (index) {
              final isLast = index == (poll.options ?? []).length - 1;
              return Padding(
                padding: EdgeInsets.only(bottom: isLast ? 0 : 8),
                child: _SalmonPollOption(option: poll.options![index]),
              );
            },
          ),
        ],
      ),
    );
  }
}
