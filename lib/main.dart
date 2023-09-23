import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:salmon/salmon.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:get_storage/get_storage.dart';
import 'firebase_options.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await dotenv.load();

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
  await initializeDateFormatting('ar');

  runApp(
    const ProviderScope(
      child: Salmon(),
    ),
  );
}
