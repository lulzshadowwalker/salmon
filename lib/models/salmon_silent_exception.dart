import 'package:flutter/foundation.dart';

@immutable
final class SalmonSilentException implements Exception {
  const SalmonSilentException(this.message);

  final String message;
}