import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:salmon/helpers/salmon_extensions.dart';
import 'package:salmon/helpers/salmon_helpers.dart';
import 'package:salmon/views/shared/salmon_navigator/salmon_navigator.dart';
import 'package:salmon/views/shared/salmon_single_child_scroll_view/salmon_single_child_scroll_view.dart';

import '../../helpers/salmon_anims.dart';
import '../../providers/chat/chat_provider.dart';
import '../shared/salmon_info_dialog/salmon_info_dialog.dart';
import '../shared/salmon_loading_indicator/salmon_loading_indicator.dart';
import 'components/channel_list.dart';
import 'components/chat_search_agency_button.dart';

class Chat extends HookConsumerWidget {
  const Chat({super.key});

  static final _log = SalmonHelpers.getLogger('Chat');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatUser = ref.watch(chatUserProvider);

    useEffect(() {
      // TODO custom hook
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        SalmonHelpers.maybeShowIntroductoryDialog(
          context: context,
          builder: (context) {
            return SalmonInfoDialog(
              title: 'Let\'s talk!',
              subtitle: 'we are listening',
              child: Lottie.asset(
                SalmonAnims.shapes,
              ),
            );
          },
          id: 'chat',
        );
      });

      return null;
    }, const []);

    return SalmonNavigator(
      child: Builder(
        builder: (context) {
          return chatUser.when(
            data: (user) => Scaffold(
              floatingActionButton: user != null
                  ? const ChatSearchAgencyButton()
                  : const SizedBox.shrink(),
              body: SalmonSingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsetsDirectional.only(start: 12),
                              child: Text(
                                'Chat', // TODO tr
                                style:
                                    context.textTheme.headlineMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Expanded(
                              child: user != null
                                  ? const ChannelList()
                                  : const Center(
                                      child: Text(
                                          'needs auth'), // TODO chat auth wrapper ui
                                    ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            error: (error, stackTrace) {
              _log.e(error);

              return const Center(
                child: Text('unknown error has occurred'), // TODO error widget
              );
            },
            loading: () => const Center(
              child: SalmonLoadingIndicator(),
            ),
          );
        },
      ),
    );
  }
}
