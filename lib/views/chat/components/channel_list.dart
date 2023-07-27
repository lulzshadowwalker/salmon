import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:salmon/helpers/salmon_extensions.dart';
import 'package:salmon/helpers/salmon_images.dart';
import 'package:salmon/views/shared/salmon_loading_indicator/salmon_loading_indicator.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../../../theme/salmon_colors.dart';
import 'channel_view.dart';
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
                    // TODO tr
                    'fetching your messages',
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
                child: Lottie.network(
                  // TODO Lottie asset
                  'https://lottie.host/9214f179-ac41-433b-8185-ac9d6737c8fb/nNFN8uCDXD.json',
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 48,
                child: AnimatedTextKit(
                  isRepeatingAnimation: false,
                  animatedTexts: [
                    TyperAnimatedText(
                      // TODO tr
                      'Start by having your first chat\ntell us what you think!',
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
                      color: SalmonColors.blue,
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
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return StreamChannel(
                      channel: channel,
                      child: const ChannelView(),
                    );
                  },
                ),
              );
            },
            leading: ChatAvatar(
              imageUrl: items[index].image ?? SalmonImages.notFound,
            ),
          );
        },
        onChannelTap: (channel) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return StreamChannel(
                  channel: channel,
                  child: const ChannelView(),
                );
              },
            ),
          );
        },
      ),
    );
  }
}