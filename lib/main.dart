import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:salmon/helpers/salmon_helpers.dart';
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

  // if (kDebugMode) {
  //   try {
  //     FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
  //     await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  //     await FirebaseStorage.instance.useStorageEmulator('localhost', 9199);
  //   } catch (e) {
  //     SalmonHelpers.getLogger('main()').e(e);
  //   }
  // }

  await GetStorage.init();
  await NotifController().init();

  runApp(
    const ProviderScope(
      child: Salmon(),
    ),
  );
}
