import 'package:flutter/material.dart';

final class SalmonColors {
  static Color fromHex(String hexColor, [String opacity = 'FF']) {
    final String color = hexColor.replaceAll('#', '');

    return Color(int.parse(opacity + color, radix: 16));
  }

  static final Color black = fromHex('0D160B');
  static final Color white = fromHex('F4FAFF');
  static final Color green = fromHex('#70EA71');
  static final Color red = fromHex('#ff4b4b');
  static const Color blue = Color(0xFF1E59C7);
  static const Color lightBlue = Color(0xBD3B6BC4);
  static final Color muted = fromHex('999999');
  static Color mutedLight = Colors.grey.shade200;
}
