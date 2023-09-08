import 'package:flutter/material.dart';
import 'package:salmon/helpers/salmon_extensions.dart';
import 'package:salmon/helpers/salmon_images.dart';
import 'package:salmon/views/chat/components/chat_avatar.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../../../theme/salmon_colors.dart';
import '../../shared/app_bar_divider/app_bar_divider.dart';

class ChannelView extends StatefulWidget {
  const ChannelView({
    required this.channel,
    Key? key,
  }) : super(key: key);

  final Channel channel;

  @override
  State<ChannelView> createState() => _ChannelViewState();
}

class _ChannelViewState extends State<ChannelView> {
  @override
  void initState() {
    super.initState();
    widget.channel.watch();
  }

  @override
  void dispose() {
    widget.channel.stopWatching();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamChannel(
      channel: widget.channel,
      child: Builder(builder: (context) {
        return Scaffold(
          appBar: AppBar(
            bottom: const AppBarDivider(),
            centerTitle: false,
            title: Row(
              children: [
                ChatAvatar(
                  imageUrl: widget.channel.image ?? SalmonImages.notFound,
                  backgroundColor: Colors.transparent,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    widget.channel.name ?? context.sl.liveChat,
                    maxLines: 2,
                    style: context.textTheme.titleMedium?.copyWith(
                      color: SalmonColors.white,
                    ),
                  ),
                ),
              ],
            ),
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: SalmonColors.white,
          ),
          body: const Column(
            children: <Widget>[
              Expanded(
                child: StreamMessageListView(),
              ),
              StreamMessageInput(
                showCommandsButton: false,
                sendButtonLocation: SendButtonLocation.inside,
              ),
            ],
          ),
        );
      }),
    );
  }
}
