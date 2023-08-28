// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:salmon/helpers/salmon_extensions.dart';
import 'package:salmon/helpers/salmon_images.dart';
import 'package:search_page/search_page.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../../../models/agency.dart';
import '../../../providers/a12n/a12n_provider.dart';
import '../../../providers/agencies/agencies_provider.dart';
import '../../../providers/chat/chat_provider.dart';
import 'channel_view.dart';
import 'chat_avatar.dart';

class ChatSearchAgencyButton extends ConsumerWidget {
  const ChatSearchAgencyButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final agencies = ref.watch(agenciesProvider);

    return FloatingActionButton(
      onPressed: () => showSearch(
        context: context,
        delegate: SearchPage<Agency>(
          items: agencies.value ?? [],
          searchLabel: context.sl.connectWithUs,
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
                  (context.isEn ? agency.enName : agency.arName) ??
                      context.sl.liveChat,
                ),
                onTap: () async {
                  final uid = ref.read(a12nProvider).userId;
                  final client = ref.read(chatClientProvider);

                  final channel = Channel(
                    client,
                    'messaging',
                    '$uid${agency.id}',
                    name: context.isEn ? agency.enName : agency.arName,
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
          failure: Center(
            child: Text(context.sl.cantFindWhatYoureLookingFor),
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
              (context.isEn ? agency.enName : agency.arName) ??
                  context.sl.liveChat,
            ),
          ),
        ),
      ),
      child: const Icon(FontAwesomeIcons.plus),
    );
  }
}
