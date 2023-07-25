import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:salmon/providers/posts/posts_provider.dart';
import 'package:salmon/views/feed/components/post_card.dart';
import 'package:salmon/views/home/components/home_app_bar.dart';
import 'package:salmon/views/shared/salmon_navigator/salmon_navigator.dart';
import 'package:shimmer/shimmer.dart';

import '../../theme/salmon_colors.dart';

class Feed extends ConsumerWidget {
  const Feed({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final posts = ref.watch(postsProvider);

    // TODO locallized articles

    return SalmonNavigator(
      child: Builder(builder: (context) {
        return RefreshIndicator(
          onRefresh: () async => ref.invalidate(postsProvider),
          displacement: 65,
          backgroundColor: SalmonColors.lightYellow,
          color: SalmonColors.black,
          edgeOffset: AppBar().preferredSize.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HomeAppBar(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: ListView.builder(
                    physics: const ClampingScrollPhysics(),
                    itemCount: posts.value?.length,
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
                          loading: () => AspectRatio(
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
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
