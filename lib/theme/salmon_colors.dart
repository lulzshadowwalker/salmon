import 'package:flutter/material.dart';

final class SalmonColors {
  static Color fromHex(String hexColor, [String opacity = 'FF']) {
    final String color = hexColor.replaceAll('#', '');

    return Color(int.parse(opacity + color, radix: 16));
  }

  static const Color black = Color(0xFF1E2832);
  static final Color white = fromHex('F4FAFF');
  static final Color green = fromHex('#59C58F');
  static final Color red = fromHex('#EE4B6A');
  static final Color yellow = fromHex('F5C04E');
  static const Color blue = Color(0xFF1E59C7);
  static const Color lightBlue = Color(0xBD3B6BC4);
  static final Color muted = fromHex('999999');
  static final Color orange = fromHex('EF8354');
  static Color mutedLight = Colors.grey.shade200;
}
