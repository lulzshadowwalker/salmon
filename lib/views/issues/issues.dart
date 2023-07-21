part of './components/issues_components.dart';

class Issues extends ConsumerWidget {
  const Issues({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final submissions = ref.watch(submissionsProvider);

    return SalmonNavigator(
      child: Builder(builder: (context) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const HomeAppBar(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsetsDirectional.only(start: 12),
                      child: Text(
                        'Submissions',
                        style: context.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ), // TODO tr

                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _IssueCard(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const IssueSubmission(),
                                ),
                              );
                            },
                            title: 'Issue', // TODO tr
                            backgroundColor: SalmonColors.brown,
                            child: ColorFiltered(
                              colorFilter: const ColorFilter.mode(
                                SalmonColors.brown,
                                BlendMode.color,
                              ),
                              child: Lottie.network(
                                // TODO Lottie asset
                                'https://lottie.host/44ff4ac5-5014-4d61-88fe-436bf090769e/HOn3gUZ2Eb.json',
                                filterQuality: FilterQuality.medium,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _IssueCard(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const GenericSubmission(),
                                ),
                              );
                            },
                            title: 'Generic', // TODO tr
                            backgroundColor: SalmonColors.blue,
                            child: ColorFiltered(
                              colorFilter: const ColorFilter.mode(
                                SalmonColors.blue,
                                BlendMode.color,
                              ),
                              child: Lottie.network(
                                // TODO Lottie asset
                                'https://lottie.host/44ff4ac5-5014-4d61-88fe-436bf090769e/HOn3gUZ2Eb.json',
                                filterQuality: FilterQuality.medium,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),
                    Text(
                      'Previous Submissions', // TODO tr
                      style: context.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 12),

                    submissions.when(
                      data: (data) => Expanded(
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: data.length,
                          itemBuilder: (context, index) => _SubmissionTile(
                            index: index,
                            submission: data[index],
                          ),
                        ),
                      ),
                      error: (error, stackTrace) => const Center(
                        child: Text(
                          'Unknown error has occured', // TODO error widget (internet connection?)
                        ),
                      ),
                      loading: () => const Center(
                        child: SalmonLoadingIndicator(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
