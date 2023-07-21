import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:salmon/providers/theme_data/theme_data_provider.dart';
import 'package:salmon/router/salmon_routes.dart';
import 'package:salmon/views/feed/components/post_card_tag.dart';
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
                    imageUrl: post.coverImage ??
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
                              PostCardTag(
                                title: Text(post.tag ?? ''),
                              ),
                              const Spacer(),
                              FractionallySizedBox(
                                widthFactor: 0.75,
                                child: Text(
                                  post.title ?? 'Read more', // TODO tr
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
                              const Row(
                                children: [
                                  FaIcon(
                                    FontAwesomeIcons.handsClapping,
                                    size: 18,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    '·  2.9K',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  SizedBox(width: 16),
                                  FaIcon(
                                    FontAwesomeIcons.solidComments,
                                    size: 18,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    '·  63',
                                    style: TextStyle(fontSize: 12),
                                  ),
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
