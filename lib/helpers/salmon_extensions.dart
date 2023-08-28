import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:salmon/helpers/salmon_const.dart';

import '../l10n/l10n_imports.dart';

extension NullAwareString on String? {
  int get length => '$this'.length;

  String get maybeAsEmpty => this ?? '';

  bool get isEmpty => this == null || !this!.isNotEmpty;
}

/// returns a list without the [null] values if any
extension CompactMap<T> on Iterable<T?> {
  Iterable<T> get toCompactMap =>
      map((e) => e).where((e) => e != null).toList().cast();
}

extension Compact<T, S> on Map<T, S> {
  Map<T, S> get compact =>
      Map.from(this)..removeWhere((key, value) => value == null);
}

extension StringToImageProvider on String? {
  NetworkImage? get asNetImg => this != null ? NetworkImage(this!) : null;

  AssetImage? get asAssetImg => this != null ? AssetImage(this!) : null;

  CachedNetworkImageProvider? get asCachedNetImg =>
      this != null ? CachedNetworkImageProvider(this!) : null;
}

extension DataToMemProvider on Uint8List? {
  MemoryImage? get asMemImg => this != null ? MemoryImage(this!) : null;
}

extension Normalize on num {
  double normalized({
    required double maxVal,
    double minVal = 0,
    double lowerBound = 0,
    double upperBound = 1,
  }) =>
      minVal +
      ((this - minVal) * (upperBound - lowerBound)) / (maxVal - minVal);
}

extension DurationOperations on Duration {
  Duration operator +(Duration other) => Duration(
        days: inDays + other.inDays,
        hours: inHours + other.inHours,
        minutes: inMinutes + other.inMinutes,
        seconds: inSeconds + other.inSeconds,
        milliseconds: inMilliseconds + other.inMilliseconds,
        microseconds: inMicroseconds + other.inMicroseconds,
      );

  Duration operator -(Duration other) => Duration(
        days: inDays - other.inDays,
        hours: inHours - other.inHours,
        minutes: inMinutes - other.inMinutes,
        seconds: inSeconds - other.inSeconds,
        milliseconds: inMilliseconds - other.inMilliseconds,
        microseconds: inMicroseconds - other.inMicroseconds,
      );
}

extension ContextHeleprs on BuildContext {
  TextTheme get textTheme => Theme.of(this).textTheme;

  TextDirection get directionality => Directionality.of(this);

  bool get canAnyPop => canPop() || Navigator.of(this).canPop();

  ThemeData get theme => Theme.of(this);

  MediaQueryData get mq => MediaQuery.of(this);

  ColorScheme get cs => Theme.of(this).colorScheme;

  SL get sl => SL.of(this);

  bool get isEn => SL.of(this).localeName == SalmonConst.en;
}
