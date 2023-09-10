import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:salmon/helpers/salmon_anims.dart';
import 'package:salmon/helpers/salmon_extensions.dart';
import 'package:salmon/helpers/salmon_helpers.dart';
import 'package:salmon/providers/polls/polls_provider.dart';
import 'package:salmon/providers/posts/posts_provider.dart';
import 'package:salmon/views/feed/components/post_card.dart';
import 'package:salmon/views/shared/content_filter_button/content_filter_button.dart';
import 'package:salmon/views/shared/expandable_page_view/expandable_page_view.dart';
import 'package:salmon/views/shared/salmon_info_dialog/salmon_info_dialog.dart';
import 'package:salmon/views/shared/salmon_navigator/salmon_navigator.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../theme/salmon_colors.dart';
import '../shared/salmon_poll/components/salmon_poll_components.dart';

class Feed extends StatefulHookConsumerWidget {
  const Feed({super.key});

  @override
  ConsumerState<Feed> createState() => _FeedState();
}

class _FeedState extends ConsumerState<Feed> {
  final pageController = PageController();

  @override
  Widget build(BuildContext context) {
    final posts = ref.watch(filteredPostsProvider);

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        SalmonHelpers.maybeShowIntroductoryDialog(
          context: context,
          builder: (context) {
            return SalmonInfoDialog(
              title: 'Stay up to Date',
              subtitle: 'Keep up with what interests you!',
              child: Lottie.asset(
                SalmonAnims.flag,
                repeat: false,
              ),
            );
          },
          id: 'feed',
        );
      });

      return null;
    }, const []);

    return SalmonNavigator(
      child: Builder(builder: (context) {
        return RefreshIndicator(
          onRefresh: () async => ref.invalidate(postsProvider),
          displacement: 65,
          backgroundColor: context.cs.primaryContainer,
          color: SalmonColors.black,
          edgeOffset: AppBar().preferredSize.height,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Consumer(
                  builder: (context, ref, child) {
                    final polls = ref.watch(pollsProvider);
                    const duration = Duration(milliseconds: 650);

                    return AnimatedSwitcher(
                      duration: duration,
                      child: AnimatedSize(
                        duration: duration,
                        child: polls.when(
                          data: (data) => Column(
                            children: [
                              ExpandablePageView(
                                controller: pageController,
                                children: List.generate(
                                  data.length,
                                  (index) => Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 24,
                                    ),
                                    child: SalmonPoll(
                                      poll: data[index],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
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
                          ),
                          error: (_, __) => const SizedBox.shrink(),
                          loading: () => const SizedBox.shrink(),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsetsDirectional.only(
                    top: 16,
                    end: 12,
                  ),
                  child: Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: ContentFilterButton(),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.only(
                  top: 12,
                  right: 12,
                  left: 12,
                ),
                sliver: (posts.value ?? []).isEmpty
                    ? SliverToBoxAdapter(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FractionallySizedBox(
                              widthFactor: 0.6,
                              child: Lottie.asset(
                                SalmonAnims.emptyState,
                              ),
                            ),
                            Text(
                              context.sl.cannotFindWhatYoureLookingFor,
                              style: TextStyle(
                                color: SalmonColors.muted,
                              ),
                            ),
                          ],
                        ),
                      )
                    : SliverList.builder(
                        itemCount: (posts.value ?? []).length,
                        itemBuilder: (context, index) {
                          final isLast = posts.value?.length != null &&
                              index != (posts.value!.length - 1);

                          return Padding(
                            padding: isLast
                                ? const EdgeInsets.only(bottom: 24)
                                : EdgeInsets.zero,
                            child: posts.when(
                              data: (data) => PostCard(
                                post: data[index],
                              ), // TODO Feed empty state
                              error: (error, stackTrace) => const Center(
                                child: Text('unknown error'),
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
                          );
                        },
                      ),
              )
            ],
          ),
        );
      }),
    );
  }
}
