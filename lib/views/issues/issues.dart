part of './components/issues_components.dart';

class Issues extends HookConsumerWidget {
  const Issues({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final submissions = ref.watch(submissionsProvider);
    final isGuest = ref.watch(a12nProvider).isGuest;

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        SalmonHelpers.maybeShowIntroductoryDialog(
          context: context,
          builder: (context) {
            return SalmonInfoDialog(
              title: context.sl.issuesIntroTitle,
              subtitle: context.sl.issuesIntroDescription,
              child: Transform.scale(
                scale: 1.4,
                child: Lottie.asset(
                  SalmonAnims.mailbox,
                ),
              ),
            );
          },
          id: 'issues',
        );
      });

      return null;
    }, const []);

    return SalmonNavigator(
      // TODO scroll view
      child: Builder(
        builder: (context) {
          return SingleChildScrollView(
            child: Padding(
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
                            if (isGuest) {
                              NotifsController.showAuthGuardSnackbar(context);
                              return;
                            }

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
                            if (isGuest) {
                              NotifsController.showAuthGuardSnackbar(context);
                              return;
                            }

                            context.goNamed(SalmonRoutes.generalSubmission);
                          },
                          title: context.sl.suggestion,
                          backgroundColor: SalmonColors.blue,
                          child: Lottie.asset(
                            SalmonAnims.lightBulb,
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
                  submissions.when(
                    data: (data) => data.isNotEmpty
                        ? ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: data.length,
                            shrinkWrap: true,
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
                                  Transform.scale(
                                    scale: 1.35,
                                    child: Lottie.asset(
                                      SalmonAnims.mailbox,
                                      repeat: true,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
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
                    error: (error, stackTrace) => const SalmonUnknownError(),
                    loading: () => const Center(
                      child: SalmonLoadingIndicator(),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
