import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:salmon/salmon.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:get_storage/get_storage.dart';

import 'controllers/notif/notif_controller.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await GetStorage.init();

  await NotifController().init();

  runApp(
    const ProviderScope(
      child: Salmon(),
    ),
  );
}
