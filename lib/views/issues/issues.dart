part of './components/issues_components.dart';

class Issues extends HookConsumerWidget {
  const Issues({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final submissions = ref.watch(submissionsProvider);

    useEffect(() {
      // TODO custom hook
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        SalmonHelpers.maybeShowIntroductoryDialog(
          context: context,
          builder: (context) {
            return SalmonInfoDialog(
              title: 'We Hear You',
              subtitle: 'we value your\nconcerns and suggestions',
              child: Lottie.asset(
                SalmonAnims.shapes,
              ),
            );
          },
          id: 'issues',
        );
      });

      return null;
    }, const []);

    return SalmonNavigator(
      child: Builder(
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.only(start: 12),
                  child: Text(
                    context.sl.submissions,
                    style: context.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _IssueCard(
                        onTap: () {
                          context.goNamed(SalmonRoutes.issueSubmission);
                        },
                        title: context.sl.complaint,
                        backgroundColor: SalmonColors.brown,
                        child: ColorFiltered(
                          colorFilter: ColorFilter.mode(
                            SalmonColors.brown.withOpacity(0.05),
                            BlendMode.srcATop,
                          ),
                          child: Lottie.asset(
                            SalmonAnims.report,
                            filterQuality: FilterQuality.medium,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _IssueCard(
                        onTap: () {
                          context.goNamed(SalmonRoutes.generalSubmission);
                        },
                        title: context.sl.suggestion,
                        backgroundColor: SalmonColors.blue,
                        child: Lottie.asset(
                          SalmonAnims.shapes,
                          filterQuality: FilterQuality.medium,
                          reverse: true,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  context.sl.previousSubmissions,
                  style: context.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: submissions.when(
                    data: (data) => data.isNotEmpty
                        ? ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: data.length,
                            itemBuilder: (context, index) => _SubmissionTile(
                              index: index,
                              submission: data[index],
                            ),
                          )
                        : Center(
                            child: FractionallySizedBox(
                              widthFactor: 0.5,
                              child: Column(
                                children: [
                                  const SizedBox(height: 36),
                                  Lottie.asset(
                                    SalmonAnims.interaction,
                                    repeat: true,
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    context
                                        .sl.feelFreeToReachOutWithSuggestions,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: SalmonColors.muted,
                                    ),
                                  ),
                                ],
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
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
