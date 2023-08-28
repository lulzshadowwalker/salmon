import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:salmon/helpers/salmon_anims.dart';
import 'package:salmon/helpers/salmon_extensions.dart';
import 'package:salmon/helpers/salmon_images.dart';
import 'package:salmon/router/salmon_routes.dart';
import 'package:salmon/views/shared/salmon_loading_indicator/salmon_loading_indicator.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../../../theme/salmon_colors.dart';
import 'chat_avatar.dart';

class ChannelList extends StatefulWidget {
  const ChannelList({
    Key? key,
  }) : super(key: key);

  @override
  State<ChannelList> createState() => _ChannelListState();
}

class _ChannelListState extends State<ChannelList> {
  late final _listController = StreamChannelListController(
    client: StreamChat.of(context).client,
    filter: Filter.in_(
      'members',
      [StreamChat.of(context).currentUser!.id],
    ),
    channelStateSort: const [SortOption('last_message_at')],
    limit: 20,
  );

  @override
  void dispose() {
    _listController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamChannelListView(
        controller: _listController,
        padding: const EdgeInsets.symmetric(vertical: 12),
        loadingBuilder: (context) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SalmonLoadingIndicator(),
              AnimatedTextKit(
                isRepeatingAnimation: false,
                animatedTexts: [
                  RotateAnimatedText(
                    context.sl.fetchingMessages,
                  ),
                ],
              )
            ],
          ),
        ),
        emptyBuilder: (context) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ColorFiltered(
                colorFilter: const ColorFilter.mode(
                  SalmonColors.lightBlue,
                  BlendMode.srcIn,
                ),
                child: Lottie.asset(
                  SalmonAnims.chatBubble,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 48,
                child: AnimatedTextKit(
                  isRepeatingAnimation: false,
                  animatedTexts: [
                    TyperAnimatedText(
                      context.sl.startByHavingYourFirstChat,
                      textAlign: TextAlign.center,
                      speed: const Duration(milliseconds: 36),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        separatorBuilder: (context, values, index) => const SizedBox(height: 8),
        itemBuilder: (context, items, index, defaultWidget) {
          final channel = items[index];
          final unreadCount = channel.state?.unreadCount ?? 0;

          return defaultWidget.copyWith(
            contentPadding: EdgeInsets.zero,
            sendingIndicatorBuilder: (p0, p1) => const SizedBox.shrink(),
            unreadIndicatorBuilder: (context) => unreadCount > 0
                ? ClipOval(
                    child: Container(
                      width: 22,
                      height: 22,
                      color: context.theme.colorScheme.secondary,
                      alignment: Alignment.center,
                      child: Text(
                        unreadCount.toString(),
                        style: context.textTheme.labelSmall?.copyWith(
                          color: SalmonColors.white,
                        ),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
            onTap: () {
              context.goNamed(
                SalmonRoutes.chat,
                extra: channel,
              );
            },
            leading: ChatAvatar(
              imageUrl: items[index].image ?? SalmonImages.notFound,
            ),
          );
        },
        onChannelTap: (channel) {
          context.goNamed(
            SalmonRoutes.chat,
            extra: channel,
          );
        },
      ),
    );
  }
}
