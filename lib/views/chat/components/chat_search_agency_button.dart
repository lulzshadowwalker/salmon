// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:salmon/helpers/salmon_extensions.dart';
import 'package:salmon/helpers/salmon_images.dart';
import 'package:search_page/search_page.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../../../controllers/notifs/notifs_controller.dart';
import '../../../models/agency.dart';
import '../../../providers/a12n/a12n_provider.dart';
import '../../../providers/agencies/agencies_provider.dart';
import '../../../providers/chat/chat_provider.dart';
import '../../../router/salmon_routes.dart';
import 'chat_avatar.dart';

class ChatSearchAgencyButton extends ConsumerWidget {
  const ChatSearchAgencyButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final agencies = ref.watch(agenciesProvider(context.sl.localeName));
    final isGuest = ref.watch(a12nProvider).isGuest;

    return FloatingActionButton(
      onPressed: () {
        if (isGuest) {
          NotifsController.showAuthGuardSnackbar(context);
          return;
        }

        showSearch(
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
                    imageUrl: agency.logo ?? SalmonImages.agencyPlaceholder,
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
                      image: agency.logo ?? SalmonImages.agencyPlaceholder,
                      extraData: {
                        'members': [uid, agency.id]
                      },
                    );

                    await channel.create();
                    await channel.watch();

                    context.goNamed(
                      SalmonRoutes.chat,
                      extra: channel,
                    );

                    Navigator.of(context).pop();
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
                imageUrl: agency.logo ?? SalmonImages.agencyPlaceholder,
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
                  image: agency.logo ?? SalmonImages.agencyPlaceholder,
                  extraData: {
                    'members': [uid, agency.id]
                  },
                );

                await channel.create();
                await channel.watch();

                context.goNamed(
                  SalmonRoutes.chat,
                  extra: channel,
                );

                Navigator.of(context).pop();
              },
            ),
          ),
        );
      },
      child: const Icon(FontAwesomeIcons.plus),
    );
  }
}
