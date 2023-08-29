part of './event_components.dart';

final _isGoingProvider =
    StateProvider.autoDispose.family<bool, Event>((ref, event) {
  return ref.watch(checkEventUserProvider(event)).value != null;
});

class _EventCard extends HookConsumerWidget {
  const _EventCard({
    required this.event,
  });

  final Event event;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _EventData(
      data: event,
      child: Bounceable(
        onTap: () {
          context.goNamed(
            SalmonRoutes.eventView,
            extra: event,
          );
        },
        scaleFactor: 0.95,
        duration: const Duration(milliseconds: 30),
        reverseDuration: null,
        child: AspectRatio(
          aspectRatio: 1,
          child: Card(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: CachedNetworkImage(
              imageUrl: event.coverImage ?? // TODO placeholder image
                  'https://images.unsplash.com/photo-1615023691139-47180d57138f?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=870&q=80',
              maxHeightDiskCache: 480,
              fit: BoxFit.cover,
              placeholder: (context, url) {
                return Shimmer.fromColors(
                  baseColor: SalmonColors.mutedLight,
                  highlightColor: SalmonColors.white,
                  child: Container(
                    color: SalmonColors.mutedLight,
                    width: double.infinity,
                    height: 100,
                  ),
                );
              },
              imageBuilder: (context, imageProvider) => Stack(
                children: [
                  Positioned.fill(
                    child: Hero(
                      tag: '${event.id}${event.coverImage}',
                      child: ColorFiltered(
                        colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.15),
                          BlendMode.srcATop,
                        ),
                        child: Image(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Consumer(
                    builder: (context, ref, child) {
                      final users = ref.watch(eventUsersProvider(event));

                      return users.when(
                        data: (data) => (data ?? []).isEmpty
                            ? const SizedBox.shrink()
                            : Positioned(
                                top: 0,
                                left: 0,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 18,
                                  ),
                                  child: SalmonOverlappingStack(
                                    itemCount: data!.length,
                                    itemBuilder: (context, index) =>
                                        SalmonUserAvatar(
                                      user: data[index],
                                    ),
                                    offset: const Offset(24, 0),
                                    limit: 4,
                                    overflowBuilder: (context, amount) =>
                                        CircleAvatar(
                                            backgroundColor: SalmonColors.muted
                                                .withOpacity(0.15),
                                            radius: 16,
                                            child: Text('+$amount')),
                                  ),
                                ),
                              ),
                        error: (_, __) => const SizedBox.shrink(),
                        loading: () => const SizedBox.shrink(),
                      );
                    },
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Hero(
                        tag: '${event.id}-date',
                        child: Material(
                          color: Colors.transparent,
                          child: SalmonTagChip(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 18,
                              ),
                              child: Builder(builder: (context) {
                                final monthDay = intl.DateFormat(
                                  'MMM dd',
                                  SL.of(context).localeName,
                                )
                                    .format(
                                      event.date ?? DateTime.now(),
                                    )
                                    .split(' ');

                                final month = monthDay[0];
                                final day = monthDay[1];
                                return Text(
                                  '$month\n$day',
                                  style:
                                      context.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                );
                              }),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Spacer(),
                        if (!event.createdBy.isEmpty)
                          Hero(
                            tag: '${event.id}-agency',
                            child: Material(
                              color: Colors.transparent,
                              child: Consumer(
                                builder: (context, ref, child) {
                                  final agency = ref.watch(
                                    agencyProvider(
                                      event.createdBy!,
                                    ),
                                  );

                                  return agency.when(
                                    data: (data) => ConstrainedBox(
                                      constraints: const BoxConstraints(
                                        maxWidth: 225,
                                      ),
                                      child: Row(
                                        children: [
                                          CachedNetworkImage(
                                            imageUrl: data?.logo ?? '',
                                            height: 24,
                                            width: 24,
                                            imageBuilder:
                                                (context, imageProvider) =>
                                                    Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .only(end: 6),
                                              child: Image(
                                                image: imageProvider,
                                              ),
                                            ),
                                            errorWidget: (
                                              context,
                                              url,
                                              error,
                                            ) =>
                                                const SizedBox.shrink(),
                                          ),
                                          Expanded(
                                            child: Text(
                                              (context.isEn
                                                      ? data?.enName
                                                      : data?.arName) ??
                                                  context.sl.unknown,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    error: (error, stackTrace) =>
                                        const SizedBox.shrink(),
                                    loading: () => const SizedBox.shrink(),
                                  );
                                },
                              ),
                            ),
                          ),
                        const SizedBox(height: 6),
                        FractionallySizedBox(
                          widthFactor: 0.75,
                          child: Hero(
                            tag: '${event.id}-title',
                            child: Text(
                              (context.isEn ? event.enTitle : event.arTitle) ??
                                  context.sl.readMore,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                    color: SalmonColors.mutedLight,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 2),
                        ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxWidth: 225,
                          ),
                          child: Hero(
                            tag: '${event.id}-summary',
                            child: Material(
                              color: Colors.transparent,
                              child: Text(
                                (context.isEn
                                        ? event.enSummary
                                        : event.arSummary) ??
                                    '',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: SalmonColors.mutedLight,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const _IsGoingButton(),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
