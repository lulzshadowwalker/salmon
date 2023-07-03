import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'l10n_provider.g.dart';

@riverpod
class AsyncL10n extends _$AsyncL10n {
  static const _storageKey = 'lang_code';

  @override
  Future<Locale> build() async {
    final box = GetStorage();

    final langCode = box.read<String>(_storageKey);
    if (langCode == null) {
      await box.write(_storageKey, 'en');
      return const Locale('en');
    }

    return Locale(langCode);
  }

  Future<void> ar() async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      await GetStorage().write(_storageKey, 'ar');

      return const Locale('ar');
    });
  }

  Future<void> en() async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      await GetStorage().write(_storageKey, 'en');

      return const Locale('en');
    });
  }
}
