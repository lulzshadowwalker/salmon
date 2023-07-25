import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:salmon/helpers/salmon_images.dart';
import 'package:search_page/search_page.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../../../helpers/salmon_const.dart';
import '../../../models/agency.dart';
import '../../../providers/a12n/a12n_provider.dart';
import '../../../providers/agencies/agencies_provider.dart';
import '../../../providers/chat/chat_provider.dart';
import '../../../providers/l10n/async_l10n_provider.dart';
import 'channel_view.dart';
import 'chat_avatar.dart';

class ChatSearchAgencyButton extends ConsumerWidget {
  const ChatSearchAgencyButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final agencies = ref.watch(agenciesProvider);

    final locale = ref.watch(asyncL10nProvider).when<Locale>(
          data: (locale) => locale,
          error: (_, __) => const Locale(SalmonConst.en),
          loading: () => const Locale(SalmonConst.en),
        );

    final isArabic = locale == const Locale(SalmonConst.ar);

    return FloatingActionButton(
      onPressed: () => showSearch(
        context: context,
        delegate: SearchPage<Agency>(
          items: agencies.value ?? [],
          searchLabel: 'connect with us ..', // TODO tr
          suggestion: ListView.builder(
            itemCount: agencies.value?.length ?? 0,
            itemBuilder: (BuildContext context, int index) {
              final agency = agencies.value![index];
              return ListTile(
                leading: ChatAvatar(
                  imageUrl: agency.logo ?? SalmonImages.notFound,
                ),
                minLeadingWidth: 8,
                title: Text(
                  (isArabic ? agency.arName : agency.enName) ??
                      'Live Chat', // TODO tr
                ),
                onTap: () async {
                  final uid = ref.read(a12nProvider).userId;
                  final client = ref.read(chatClientProvider);

                  final channel = Channel(
                    client,
                    'messaging',
                    '$uid${agency.id}',
                    name: isArabic ? agency.arName : agency.enName,
                    image: agency.logo,
                    extraData: {
                      'members': [uid, agency.id]
                    },
                  );

                  await channel.create();
                  await channel.watch();

                  await Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) {
                        return StreamChannel(
                          channel: channel,
                          child: const ChannelView(),
                        );
                      },
                    ),
                  );

                  await channel.stopWatching();
                },
              );
            },
          ),
          failure: const Center(
            child: Text('Can\'t find what you are looking for?'), // TODO tr
          ),
          filter: (agency) => [
            agency.enName,
            agency.arName,
          ],
          builder: (agency) => ListTile(
            leading: ChatAvatar(
              imageUrl: agency.logo ?? SalmonImages.notFound,
            ),
            minLeadingWidth: 8,
            title: Text(
              (isArabic ? agency.arName : agency.enName) ??
                  'Live Chat', // TODO tr
            ),
          ),
        ),
      ),
      child: const Icon(FontAwesomeIcons.solidMessage),
    );
  }
}
