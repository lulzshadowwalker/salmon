import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:salmon/providers/agency/agency_provider.dart';
import 'package:salmon/providers/comment_count/comment_count_provider.dart';
import 'package:salmon/providers/theme_data/theme_data_provider.dart';
import 'package:salmon/router/salmon_routes.dart';
import 'package:salmon/views/feed/components/post_tag_chip.dart';
import 'package:shimmer/shimmer.dart';

import '../../../models/post.dart';
import '../../../theme/salmon_colors.dart';

class PostCard extends ConsumerWidget {
  const PostCard({
    required this.post,
    super.key,
  });

  final Post post;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(salmonThemeProvider).dark();
    final agency = ref.watch(agencyProvider(post.createdBy ?? ''));
    final commentCount = ref.watch(commentCountProvider(post.id!));

    return Theme(
      data: theme,
      child: DefaultTextStyle(
        style: TextStyle(
          color: SalmonColors.white,
        ),
        child: Builder(builder: (context) {
          return Bounceable(
            onTap: () {
              context.goNamed(
                SalmonRoutes.postView,
                extra: post,
              );
            },
            scaleFactor: 0.95,
            duration: const Duration(milliseconds: 30),
            reverseDuration: null,
            child: AspectRatio(
              aspectRatio: 1,
              child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: CachedNetworkImage(
                    imageUrl: post.coverImage ?? // TODO placeholder image
                        'https://images.unsplash.com/photo-1615023691139-47180d57138f?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=870&q=80',
                    maxHeightDiskCache: 480,
                    fit: BoxFit.cover,
                    placeholder: (context, url) {
                      return Shimmer.fromColors(
                        baseColor: SalmonColors.mutedLight,
                        highlightColor: SalmonColors.white,
                        child: Container(
                          color: SalmonColors.mutedLight,
                          width: double.infinity,
                          height: 100,
                        ),
                      );
                    },
                    imageBuilder: (context, imageProvider) => Stack(
                      alignment: Alignment.center,
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
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (agency.hasValue)
                                PostTagChip(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CachedNetworkImage(
                                        imageUrl: agency.value!.logo!,
                                        errorWidget: (context, url, error) =>
                                            const SizedBox.shrink(),
                                        imageBuilder:
                                            (context, imageProvider) => Padding(
                                          padding:
                                              const EdgeInsetsDirectional.only(
                                            end: 8,
                                          ),
                                          child: Image(
                                            image: imageProvider,
                                            height: 24,
                                          ),
                                        ),
                                      ),
                                      ConstrainedBox(
                                        constraints: const BoxConstraints(
                                          maxWidth: 150,
                                        ),
                                        child: Text(
                                          agency.value?.enName ?? '',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              const Spacer(),
                              FractionallySizedBox(
                                widthFactor: 0.75,
                                child: Text(
                                  post.enTitle ?? 'Read more', // TODO tr
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(
                                        color: SalmonColors.mutedLight,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ),
                              const SizedBox(height: 18),
                              Row(
                                children: [
                                  if ((post.clapCount ?? 0) != 0) ...[
                                    const FaIcon(
                                      FontAwesomeIcons.handsClapping,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      '·  ${post.clapCount}',
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                    const SizedBox(width: 16),
                                  ],
                                  if (commentCount.hasValue &&
                                      ((commentCount.value ?? 0) != 0)) ...[
                                    const FaIcon(
                                      FontAwesomeIcons.solidComments,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      '·  ${commentCount.value}',
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ]
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  )),
            ),
          );
        }),
      ),
    );
  }
}
