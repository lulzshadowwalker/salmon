import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:salmon/helpers/salmon_const.dart';

part 'async_l10n_provider.g.dart';

@Riverpod(keepAlive: true)
class AsyncL10n extends _$AsyncL10n {
  static const _storageKey = 'lang_code';

  @override
  Future<Locale> build() async {
    final box = GetStorage();

    final langCode = box.read<String>(_storageKey);
    if (langCode == null) {
      await box.write(_storageKey, SalmonConst.en);
      return const Locale(SalmonConst.en);
    }

    return Locale(langCode);
  }

  Future<void> ar() async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      await GetStorage().write(_storageKey, SalmonConst.ar);

      return const Locale(SalmonConst.ar);
    });
  }

  Future<void> en() async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      await GetStorage().write(_storageKey, SalmonConst.en);

      return const Locale(SalmonConst.en);
    });
  }
}
