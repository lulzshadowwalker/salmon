import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:salmon/models/salmon_user_credentials.dart';

final salmonUserCredentialsProvider =
    ChangeNotifierProvider<SalmonUserCredentialsNotifier>(
  (ref) => SalmonUserCredentialsNotifier(),
);

class SalmonUserCredentialsNotifier extends ChangeNotifier {
  var _credentials = const SalmonUserCredentials();

  SalmonUserCredentials get credentials => _credentials;

  void set(SalmonUserCredentials credentials) {
    _credentials = credentials;
    notifyListeners();
  }
}
