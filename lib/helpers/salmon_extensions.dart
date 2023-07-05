import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

extension NullAwareString on String? {
  int get length => '$this'.length;

  String get maybeAsEmpty => this ?? '';

  bool get isEmpty => this == null || !this!.isNotEmpty;
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
