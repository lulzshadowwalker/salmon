import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:salmon/helpers/salmon_extensions.dart';
import 'package:salmon/providers/post_comments/post_comments_provider.dart';
import 'package:salmon/providers/theme_data/theme_data_provider.dart';
import 'package:salmon/views/feed/components/comment_data.dart';
import 'package:salmon/views/feed/components/post_data.dart';
import 'package:salmon/views/shared/salmon_loading_indicator/salmon_loading_indicator.dart';
import 'package:salmon/views/shared/salmon_unfocusable_wrapper/salmon_unfocusable_wrapper.dart';
import '../../../theme/salmon_colors.dart';
import 'comment_input.dart';
import 'comment_tile.dart';

class PostComments extends StatefulHookConsumerWidget {
  const PostComments({
    super.key,
  });

  @override
  ConsumerState<PostComments> createState() => _PostCommentsState();
}

class _PostCommentsState extends ConsumerState<PostComments> {
  @override
  Widget build(BuildContext context) {
    final post = PostData.of(context)!.data;
    final theme = ref.watch(salmonThemeProvider);
    final comments = ref.watch(postCommentsProvider(post.id!));

    return SalmonUnfocusableWrapper(
      child: Theme(
        data: theme.dark(),
        child: Builder(builder: (context) {
          return Container(
            color: SalmonColors.black,
            width: double.infinity,
            child: Builder(builder: (context) {
              return DefaultTextStyle(
                style: context.textTheme.bodyLarge!,
                child: SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsetsDirectional.only(
                          start: 28,
                          top: 24,
                        ),
                        child: Text(
                          'Comments', // TODO tr
                          style: context.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),
                      Expanded(
                        child: comments.when(
                          data: (data) => data.isEmpty
                              ? const Center(
                                  child: Text('no comments yet'),
                                )
                              : Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  child: ListView.builder(
                                    physics: const ClampingScrollPhysics(),
                                    itemCount: data.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      final comment = data[index];
                                      if (comment == null ||
                                          comment.comment.isEmpty) return null;

                                      return CommentData(
                                        data: comment,
                                        child: const CommentTile(),
                                      );
                                    },
                                  ),
                                ),
                          error: (error, stackTrace) => const Center(
                            // TODO error widget
                            child: Text('unknown error has occurred'),
                          ),
                          loading: () => const Center(
                            child: SalmonLoadingIndicator(),
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        child: CommentInput(),
                      ),
                    ],
                  ),
                ),
              );
            }),
          );
        }),
      ),
    );
  }
}
