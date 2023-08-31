import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../a12n/a12n_provider.dart';

final chatClientProvider = Provider(
  (ref) => StreamChatClient(dotenv.env['CHAT_API_KEY']!),
);

final chatUserProvider = FutureProvider<OwnUser?>(
  (ref) async {
    final isGuest = ref.watch(a12nProvider).isGuest;
    if (isGuest) return null;

    final client = ref.watch(chatClientProvider);

    ref.watch(authStateProvider);
    final auth = ref.watch(a12nProvider);

    if (!auth.isAuthenticated || auth.isGuest) {
      await client.disconnectUser();
      return null;
    }

    await client.disconnectUser();
    return client.connectUser(
      User(id: auth.userId!),
      client.devToken(auth.userId!).rawValue,
    );
  },
);
