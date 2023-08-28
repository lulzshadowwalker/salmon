part of './event_components.dart';

class EventView extends StatelessWidget {
  const EventView({
    required this.event,
    super.key,
  });

  final Event event;

  @override
  Widget build(BuildContext context) {
    // TODO location text + Google Maps
    return _EventData(
      data: event,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        body: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  SalmonSingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    child: Column(
                      children: [
                        CachedNetworkImage(
                          imageUrl:
                              'https://images.unsplash.com/photo-1682685797660-3d847763208e?ixlib=rb-4.0.3&ixid=M3wxMjA3fDF8MHxlZGl0b3JpYWwtZmVlZHwyNnx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=800&q=60' ??
                                  '', // TODO placeholder
                          width: double.infinity,
                          height: context.mq.size.height * .42,
                          fit: BoxFit.cover,
                          imageBuilder: (context, imageProvider) => Stack(
                            children: [
                              Positioned.fill(
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
                              PositionedDirectional(
                                bottom: 24,
                                start: 24,
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                    maxWidth: context.mq.size.width * 0.65,
                                  ),
                                  child: Text(
                                    event.enTitle ?? '',
                                    style: context.textTheme.headlineSmall
                                        ?.copyWith(
                                      color: SalmonColors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // TODO add parallex effect
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 28),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            if (event.enSummary != null)
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 8),
                                                child:
                                                    Text(event.enSummary ?? ''),
                                              ),
                                            Consumer(
                                              builder: (context, ref, child) {
                                                final agency = ref.watch(
                                                  agencyProvider(
                                                      event.createdBy ?? ''),
                                                );

                                                return agency.when(
                                                  data: (data) => Row(
                                                    children: [
                                                      CachedNetworkImage(
                                                        imageUrl:
                                                            data?.logo ?? '',
                                                        height: 24,
                                                        width: 24,
                                                        imageBuilder: (context,
                                                                imageProvider) =>
                                                            Padding(
                                                                padding:
                                                                    const EdgeInsetsDirectional
                                                                            .only(
                                                                        end: 8),
                                                                child: Image(
                                                                  image:
                                                                      imageProvider,
                                                                )),
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            const SizedBox
                                                                .shrink(),
                                                      ),

                                                      Expanded(
                                                        child: Text(
                                                          data?.enName ??
                                                              'unknown',
                                                          style: TextStyle(
                                                            color: SalmonColors
                                                                .muted,
                                                          ),
                                                        ),
                                                      ), // TODO tr
                                                    ],
                                                  ),
                                                  error: (error, stackTrace) =>
                                                      const SizedBox.shrink(),
                                                  loading: () =>
                                                      const SizedBox.shrink(),
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      SalmonTagChip(
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
                                              style: context
                                                  .textTheme.titleMedium
                                                  ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                              textAlign: TextAlign.center,
                                            );
                                          }),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    const FaIcon(
                                      FontAwesomeIcons.locationDot,
                                      size: 22,
                                      color: Colors.red,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(event.enLocationTitle ??
                                        'See location on map'),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                AspectRatio(
                                  aspectRatio: 3 / 4,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: GoogleMap(
                                      initialCameraPosition: CameraPosition(
                                        target: event.location?.longitude !=
                                                    null ||
                                                event.location?.latitude != null
                                            ? LatLng(
                                                event.location!.longitude!,
                                                event.location!.latitude!,
                                              )
                                            : const LatLng(31.9454, 35.9284),
                                        zoom: 15.0,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: SafeArea(
                                    top: false,
                                    child: MarkdownBody(
                                      data: event.enBody ??
                                          ''.replaceAll('<br>', '\n'),
                                      styleSheet:
                                          SalmonTheme.markdownStyleSheet(
                                              context),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (context.canAnyPop)
                    PositionedDirectional(
                      top: 24,
                      start: 24,
                      child: SafeArea(
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: SalmonColors.mutedLight.withOpacity(0.5),
                          ),
                          alignment: Alignment.center,
                          width: 42,
                          height: 42,
                          child: IconButton(
                            onPressed: () {
                              context.canPop()
                                  ? context.pop()
                                  : Navigator.of(context).pop();
                            },
                            icon: FaIcon(
                              context.directionality == TextDirection.ltr
                                  ? FontAwesomeIcons.angleLeft
                                  : FontAwesomeIcons.angleRight,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SafeArea(
              top: false,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: _IsGoingButton(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}