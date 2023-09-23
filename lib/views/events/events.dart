part of './components/event_components.dart';

class Events extends ConsumerWidget {
  const Events({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(salmonThemeProvider).dark();
    final events = ref.watch(filteredEventsProvider);

    return Scaffold(
      drawer: const SalmonDrawer(),
      appBar: AppBar(
        leading: const MenuButton(),
        title: Text(SL.of(context).events),
        bottom: const AppBarDivider(),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 4,
                ),
                child: ContentFilterButton(),
              ),
              Expanded(
                child: Builder(builder: (context) {
                  return events.when(
                    data: (data) => data.isEmpty
                        ? Center(
                            child: Column(
                              children: [
                                const Spacer(),
                                FractionallySizedBox(
                                  widthFactor: 0.9,
                                  child: Lottie.asset(
                                    SalmonAnims.calendar,
                                  ),
                                ),
                                const SizedBox(height: 28),
                                Text(
                                  context.sl.noEventsAreScheduled,
                                  style: TextStyle(
                                    color: SalmonColors.muted,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const Spacer(flex: 2),
                              ],
                            ),
                          )
                        : Column(
                            children: [
                              Expanded(
                                child: Theme(
                                  data: theme,
                                  child: DefaultTextStyle(
                                    style: const TextStyle(
                                      color: SalmonColors.white,
                                    ),
                                    child: GridView.builder(
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount:
                                            context.mq.size.width >= 480
                                                ? 2
                                                : 1,
                                      ),
                                      itemCount: data.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return _EventCard(
                                          event: data[index],
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                    error: (error, stackTrace) => const SalmonUnknownError(),
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
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
