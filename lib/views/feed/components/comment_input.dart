import 'package:detectable_text_field/detector/sample_regular_expressions.dart';
import 'package:detectable_text_field/widgets/detectable_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:salmon/views/feed/components/post_data.dart';

import '../../../providers/current_user/current_user_provider.dart';
import '../../../providers/db/remote_db/remote_db_provider.dart';
import '../../../theme/salmon_colors.dart';
import '../../shared/salmon_user_avatar/salmon_user_avatar.dart';

class CommentInput extends StatefulHookConsumerWidget {
  const CommentInput({super.key});

  @override
  ConsumerState<CommentInput> createState() => _CommentInputState();
}

class _CommentInputState extends ConsumerState<CommentInput> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    final inputController = useTextEditingController();
    final post = PostData.of(context)!.data;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (user.hasValue)
          Container(
            margin: const EdgeInsetsDirectional.only(
              end: 12,
              bottom: 4,
            ),
            child: SalmonUserAvatar(user: user.value!),
          ),
        Expanded(
          child: DetectableTextField(
            controller: inputController,
            detectionRegExp: hashTagAtSignUrlRegExp,
            decoratedStyle: TextStyle(
              fontSize: 14,
              color: Theme.of(context).colorScheme.primary,
            ),
            basicStyle: const TextStyle(
              fontSize: 14,
            ),
            decoration: InputDecoration(
              hintText: 'share your thoughts ..', // TODO tr
              suffixIcon: GestureDetector(
                onTap: () async {
                  final value = inputController.value.text.trim();
                  if (value.isEmpty) return;

                  await ref.read(remoteDbProvider).comment(
                        post: post,
                        comment: value,
                      );

                  inputController.clear();
                },
                child: const Icon(
                  FontAwesomeIcons.paperPlane,
                  size: 20,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
                borderSide: BorderSide(color: SalmonColors.muted),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
