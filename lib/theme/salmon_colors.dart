import 'package:flutter/material.dart';

final class SalmonColors {
  static Color fromHex(String hexColor, [String opacity = 'FF']) {
    final String color = hexColor.replaceAll('#', '');
    return Color(int.parse(opacity + color, radix: 16));
  }

  static const Color black = Color(0xFF1C1C23);
  static const Color white = Color(0xFFf5f5f5);
  static final Color green = fromHex('#59c55b');
  static final Color red = fromHex('#EE4B6A');
  static final Color yellow = fromHex('F5C04E');
  static final Color lightYellow = yellow.withOpacity(0.6);
  static const Color blue = Color(0xFF517fe7);
  static const Color brown = Colors.brown;
  static final Color lightBrown = Colors.brown.shade400;
  static const Color lightBlue = Color(0xFF9BBEFF);
  static final Color muted = fromHex('999999');
  static final Color orange = fromHex('EF8354');
  static Color mutedLight = Colors.grey.shade200;
}
