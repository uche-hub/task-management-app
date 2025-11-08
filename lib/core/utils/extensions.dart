import 'package:flutter/material.dart';

extension ColorX on Color {
  Color withValues({required double alpha}) {
    if (alpha < 0.0 || alpha > 1.0) {
      throw ArgumentError.value(alpha, 'alpha', 'Must be between 0.0 and 1.0');
    }
    final int newAlpha = (255 * alpha).round();
    return withAlpha(newAlpha);
  }

  int toARGB32() => toARGB32();

  static Color fromARGB32(int value) => Color(value);
}