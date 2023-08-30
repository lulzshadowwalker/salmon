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
          child: Builder(builder: (context) {
            return events.when(
              data: (data) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 4.0,
                      vertical: 4,
                    ),
                    child: ContentFilterButton(),
                  ),
                  Expanded(
                    child: Theme(
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
                  ),
                ],
              ),
              error: (error, stackTrace) => const Center(
                child: Text('unknown error has occurred'), // TODO error wiget
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
            );
          }),
        ),
      ),
    );
  }
}
