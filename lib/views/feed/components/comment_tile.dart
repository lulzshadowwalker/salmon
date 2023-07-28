import 'package:detectable_text_field/detector/sample_regular_expressions.dart';
import 'package:detectable_text_field/widgets/detectable_text.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:salmon/helpers/salmon_extensions.dart';

import '../../../helpers/salmon_helpers.dart';
import '../../../providers/user/user_provider.dart';
import '../../../theme/salmon_colors.dart';
import 'comment_avatar.dart';
import 'comment_data.dart';

class CommentTile extends StatelessWidget {
  const CommentTile({
    this.isLast = false,
    super.key,
  });

  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final comment = CommentData.of(context)!.data;

    return Consumer(
      builder: (context, ref, child) {
        final author = ref.watch(
          userProvider(comment.userId!),
        );
        return Padding(
          padding: EdgeInsets.only(bottom: !isLast ? 22 : 0),
          child: AnimatedSwitcher(
            duration: const Duration(
              milliseconds: 280,
            ),
            child: author.hasValue
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommentAvatar(
                        imageUrl: author.value?.pfp,
                        size: 28,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  author.value?.displayName ??
                                      'unknown', // TODO tr
                                  style:
                                      context.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                if (comment.createdOn != null)
                                  Text(
                                    SalmonHelpers.formatTime(
                                        context, comment.createdOn!),
                                    style: TextStyle(
                                      color: SalmonColors.muted,
                                      fontSize: 12,
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            DetectableText(
                              text: comment.comment!,
                              detectionRegExp: hashTagAtSignUrlRegExp,
                              detectedStyle: TextStyle(
                                fontSize: 14,
                                color: SalmonColors.yellow,
                              ),
                              basicStyle: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : const SizedBox.shrink(),
          ),
        );
      },
    );
  }
}
