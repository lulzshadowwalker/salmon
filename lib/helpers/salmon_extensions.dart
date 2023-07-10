import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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
