import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:salmon/controllers/polls/polls_controller.dart';
import 'package:salmon/helpers/salmon_extensions.dart';
import 'package:salmon/providers/submissions_count/submissions_count_provider.dart';
import 'package:salmon/providers/users_count/users_count_provider.dart';
import 'package:salmon/views/shared/salmon_poll/components/salmon_poll_pie_chart.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../l10n/l10n_imports.dart';
import '../../providers/polls/polls_provider.dart';
import '../../theme/salmon_colors.dart';
import '../salmon_drawer/components/salmon_drawer_components.dart';
import '../shared/app_bar_divider/app_bar_divider.dart';
import '../shared/expandable_page_view/expandable_page_view.dart';
import '../shared/menu_button/menu_button.dart';

class Analytics extends StatefulHookConsumerWidget {
  const Analytics({
    super.key,
  });

  @override
  ConsumerState<Analytics> createState() => _AnalyticsState();
}

class _AnalyticsState extends ConsumerState<Analytics> {
  final pageController = PageController();

  @override
  Widget build(BuildContext context) {
        useEffect(() {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
      
      return () =>{
         SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft,

      ])
      };
    }, const []);
    return Scaffold(
      drawer: const SalmonDrawer(),
      appBar: AppBar(
        leading: const MenuButton(),
        title: Text(SL.of(context).analytics),
        bottom: const AppBarDivider(),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Consumer(
                builder: (context, ref, child) {
                  final count = ref.watch(usersCountProvider);

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AnimatedFlipCounter(
                          value: count.value ?? 56,
                          curve: Curves.easeOutQuad,
                          duration: const Duration(milliseconds: 450),
                          textStyle: const TextStyle(
                            fontSize: 100,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        FittedBox(
                          child: Text(
                            context.sl.activeCitizensOnSalmon,
                            style: context.textTheme.headlineLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const Divider(height: 48),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: FittedBox(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Consumer(
                              builder: (context, ref, child) {
                                final count =
                                    ref.watch(submissionsCountProvider);

                                return AnimatedFlipCounter(
                                  value: count.value ?? 94,
                                  curve: Curves.easeOutQuad,
                                  duration: const Duration(milliseconds: 1250),
                                  textStyle: const TextStyle(
                                    fontSize: 100,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              },
                            ),
                            Text(
                              context.sl.submissions.toLowerCase(),
                              style: context.textTheme.headlineLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 48),
                    Expanded(
                      flex: 3,
                      child: FittedBox(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Consumer(
                              builder: (context, ref, child) {
                                final count =
                                    ref.watch(resolvedSubmissionsCountProvider);

                                return AnimatedFlipCounter(
                                  value: count.value ?? 84,
                                  curve: Curves.easeOutQuad,
                                  duration: const Duration(milliseconds: 1250),
                                  textStyle: const TextStyle(
                                    fontSize: 100,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              },
                            ),
                            Text(
                              context.sl.resolved.toLowerCase(),
                              style: context.textTheme.headlineLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 48),
              Consumer(
                builder: (context, ref, child) {
                  final polls = ref.watch(pollsProvider);
                  const duration = Duration(milliseconds: 750);

                  return AnimatedSwitcher(
                    duration: duration,
                    child: AnimatedSize(
                      duration: duration,
                      curve: Curves.easeOut,
                      child: polls.when(
                        data: (data) {
                          return Column(
                            children: [
                              ExpandablePageView(
                                controller: pageController,
                                children: List.generate(data.length, (index) {
                                  final poll = data[index];

                                  return Consumer(
                                    builder: (context, ref, child) {
                                      final totalCount = ref.watch(
                                        pollVotesProvider(poll.id ?? ''),
                                      );

                                      return totalCount.when(
                                        data: (count) => count.isEmpty
                                            ? const SizedBox.shrink()
                                            : Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 12,
                                                ),
                                                child: SalmonPollPieChart(
                                                  poll: data[index],
                                                ),
                                              ),
                                        error: (error, stackTrace) =>
                                            const SizedBox.shrink(),
                                        loading: () => const SizedBox.shrink(),
                                      );
                                    },
                                  );
                                }),
                              ),
                              const SizedBox(height: 16),
                              SmoothPageIndicator(
                                controller: pageController,
                                count: data.length,
                                effect: WormEffect(
                                  dotColor: SalmonColors.muted,
                                  activeDotColor: context.cs.primary,
                                  dotHeight: 8,
                                  dotWidth: 8,
                                  type: WormType.thin,
                                ),
                              ),
                            ],
                          );
                        },
                        error: (_, __) => const SizedBox.shrink(),
                        loading: () => const SizedBox.shrink(),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
