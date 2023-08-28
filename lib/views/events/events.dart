part of './components/event_components.dart';

class Events extends ConsumerWidget {
  const Events({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(salmonThemeProvider).dark();
    final events = ref.watch(eventsProvider);

    return Scaffold(
      drawer: const SalmonDrawer(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Builder(builder: (context) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const HomeAppBar(),
                Padding(
                  padding: const EdgeInsetsDirectional.only(
                    start: 12,
                    top: 12,
                  ),
                  child: Text(
                    context.sl.events,
                    style: context.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: events.when(
                    data: (data) => Theme(
                      data: theme,
                      child: DefaultTextStyle(
                        style: TextStyle(
                          color: SalmonColors.white,
                        ),
                        child: ListView.builder(
                          itemCount: data.length,
                          itemBuilder: (BuildContext context, int index) =>
                              _EventCard(
                            event: data[index],
                          ),
                        ),
                      ),
                    ),
                    error: (error, stackTrace) => const Center(
                      child: Text(
                          'unknown error has occurred'), // TODO error wiget
                    ),
                    loading: () => ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) => AspectRatio(
                        aspectRatio: 1,
                        child: Shimmer.fromColors(
                          baseColor: SalmonColors.mutedLight,
                          highlightColor: SalmonColors.white,
                          child: Container(
                            color: SalmonColors.mutedLight,
                            width: double.infinity,
                            height: 100,
                          ),
                        ),
                      ),
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 16),
                      itemCount: 6,
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
