import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:salmon/helpers/salmon_extensions.dart';
import 'package:salmon/helpers/salmon_helpers.dart';
import 'package:salmon/views/home/components/home_app_bar.dart';
import 'package:salmon/views/shared/salmon_navigator/salmon_navigator.dart';

import '../../providers/chat/chat_provider.dart';
import '../shared/salmon_loading_indicator/salmon_loading_indicator.dart';
import 'components/channel_list.dart';
import 'components/chat_search_agency_button.dart';

class Chat extends HookConsumerWidget {
  const Chat({super.key});

  static final _log = SalmonHelpers.getLogger('Chat');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatUser = ref.watch(chatUserProvider);

    return SalmonNavigator(
      child: Builder(builder: (context) {
        return chatUser.when(
          data: (user) => Scaffold(
            floatingActionButton: user != null
                ? const ChatSearchAgencyButton()
                : const SizedBox.shrink(),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const HomeAppBar(),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsetsDirectional.only(start: 12),
                          child: Text(
                            'Chat', // TODO tr
                            style: context.textTheme.headlineMedium?.copyWith(
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
      }),
    );
  }
}
