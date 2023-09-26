import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:salmon/helpers/salmon_extensions.dart';
import 'package:salmon/helpers/salmon_images.dart';
import 'package:salmon/views/chat/components/chat_avatar.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import '../../../theme/salmon_colors.dart';

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
  late final inputController = StreamMessageInputController();

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

  void handleAttachments(List<AttachmentPickerType> types) {
    assert(
      types.isNotEmpty,
      'you have to provide a non-empty list of types for the attachment picker',
    );

    showStreamAttachmentPickerModalBottomSheet(
      initialAttachments: [
        ...inputController.attachments,
      ],
      context: context,
      allowedTypes: types,
    ).then(
      (res) {
        if (res == null) {
          return;
        }

        if (res.runtimeType == Attachment) {
          inputController.clearAttachments();
          inputController.addAttachment(res);
          return;
        }

        if ((res.runtimeType == List<Attachment>) && res.length != 0) {
          inputController.clearAttachments();
          inputController.attachments = res;
          return;
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamChannel(
      channel: widget.channel,
      child: Builder(builder: (context) {
        return Scaffold(
          appBar: AppBar(
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
          body: Column(
            children: <Widget>[
              const Expanded(
                child: StreamMessageListView(),
              ),
              StreamMessageInput(
                messageInputController: inputController,
                showCommandsButton: false,
                sendButtonLocation: SendButtonLocation.inside,
                disableAttachments: true,
                actions: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: GestureDetector(
                      onTap: () =>
                          handleAttachments([AttachmentPickerType.files]),
                      child: Icon(
                        FontAwesomeIcons.paperclip,
                        size: 18.0,
                        color: StreamChatTheme.of(context)
                            .colorTheme
                            .textLowEmphasis,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: GestureDetector(
                      onTap: () =>
                          handleAttachments([AttachmentPickerType.images]),
                      child: Icon(
                        FontAwesomeIcons.camera,
                        size: 18.0,
                        color: StreamChatTheme.of(context)
                            .colorTheme
                            .textLowEmphasis,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: GestureDetector(
                      onTap: () =>
                          handleAttachments([AttachmentPickerType.videos]),
                      child: Icon(
                        FontAwesomeIcons.video,
                        size: 18.0,
                        color: StreamChatTheme.of(context)
                            .colorTheme
                            .textLowEmphasis,
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        );
      }),
    );
  }
}
