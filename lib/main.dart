import 'package:flutter/material.dart';
import 'package:salmon/salmon.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  await GetStorage.init();

  runApp(
    const ProviderScope(
      child: Salmon(),
    ),
  );
}
