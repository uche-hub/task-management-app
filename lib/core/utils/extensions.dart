// lib/core/utils/extensions.dart

import 'package:flutter/material.dart';

extension ColorX on Color {
  /// Replaces deprecated `withOpacity` which returns Color
  /// with a new method that uses alpha.
  Color withValues({required double alpha}) {
    if (alpha < 0.0 || alpha > 1.0) {
      throw ArgumentError.value(alpha, 'alpha', 'Must be between 0.0 and 1.0');
    }
    final int newAlpha = (255 * alpha).round();
    return withAlpha(newAlpha);
  }

  /// Converts a Color to a 32-bit ARGB integer value for database storage.
  int toARGB32() => toARGB32();

  /// Creates a Color from a 32-bit ARGB integer value from the database.
  static Color fromARGB32(int value) => Color(value);
}