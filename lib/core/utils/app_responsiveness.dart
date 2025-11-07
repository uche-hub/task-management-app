// lib/utils/responsive_size.dart
import 'dart:math'; // ← ADD THIS
import 'package:flutter/widgets.dart';

enum DeviceType { phone, tablet }

class ResponsiveSize {
  static late double screenWidth;
  static late double screenHeight;
  static late DeviceType deviceType;

  static void init(BuildContext context) {
    final size = MediaQuery.of(context).size;
    screenWidth = size.width;
    screenHeight = size.height;

    final shortestSide = size.shortestSide;
    deviceType = shortestSide >= 600 ? DeviceType.tablet : DeviceType.phone;
  }

  // HEIGHT
  static double height(double size) {
    const double phoneRef = 812.0;
    const double tabletRef = 1024.0;
    final ref = deviceType == DeviceType.tablet ? tabletRef : phoneRef;
    return size * (screenHeight / ref);
  }

  // WIDTH
  static double width(double size) {
    const double phoneRef = 375.0;
    const double tabletRef = 768.0;
    final ref = deviceType == DeviceType.tablet ? tabletRef : phoneRef;
    return size * (screenWidth / ref);
  }

  // FONT SIZE (with max cap for tablets)
  static double fontSize(double size) {
    const double phoneRef = 375.0;
    const double tabletRef = 768.0;
    final ref = deviceType == DeviceType.tablet ? tabletRef : phoneRef;
    final scaled = size * (screenWidth / ref);

    // Replace coerceAtMost with min()
    return deviceType == DeviceType.tablet ? min(scaled, size * 1.4) : scaled;
  }

  // RADIUS & SPACING
  static double radius(double size) => width(size);
  static double spacing(double size) => width(size);
  static double icon(double size) => width(size);

  // GETTERS
  static bool get isTablet => deviceType == DeviceType.tablet;
  static bool get isPhone => deviceType == DeviceType.phone;
}