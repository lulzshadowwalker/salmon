import 'package:flutter/material.dart';
import 'package:salmon/helpers/salmon_extensions.dart';
import 'package:salmon/helpers/salmon_images.dart';
import 'package:salmon/views/chat/components/chat_avatar.dart';
import 'package:salmon/views/salmon_drawer/components/salmon_drawer_components.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../../../theme/salmon_colors.dart';
import '../../shared/app_bar_divider/app_bar_divider.dart';
import '../../shared/menu_button/menu_button.dart';

class ChannelView extends StatelessWidget {
  const ChannelView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final channel = StreamChannel.of(context).channel;

    return Scaffold(
      appBar: AppBar(
        bottom: const AppBarDivider(),
        titleSpacing: 12,
        title: Row(
          children: [
            ChatAvatar(
              imageUrl: channel.image ?? SalmonImages.notFound,
              backgroundColor: Colors.transparent,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                channel.name ?? 'Live Chat', // TODO tr
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
  }
}
