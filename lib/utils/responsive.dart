import 'package:flutter/material.dart';

class Responsive {
  // Breakpoints
  static const double mobileMaxWidth = 600;
  static const double tabletMaxWidth = 1024;

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < mobileMaxWidth;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= mobileMaxWidth &&
      MediaQuery.of(context).size.width < tabletMaxWidth;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= tabletMaxWidth;

  /// Returns a value based on screen size
  static T value<T>(
    BuildContext context, {
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    if (isDesktop(context)) return desktop ?? tablet ?? mobile;
    if (isTablet(context)) return tablet ?? mobile;
    return mobile;
  }

  /// Number of grid columns based on screen size
  static int gridColumns(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= 1200) return 4;
    if (width >= 900) return 3;
    if (width >= 600) return 2;
    return 2;
  }

  /// Horizontal padding based on screen size
  static double horizontalPadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= 1200) return width * 0.15;
    if (width >= 900) return width * 0.08;
    if (width >= 600) return width * 0.04;
    return 16;
  }

  /// Font scale factor
  static double fontScale(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= 1200) return 1.2;
    if (width >= 900) return 1.1;
    if (width >= 600) return 1.05;
    return 1.0;
  }

  /// Max content width for wide screens (centers content)
  static double maxContentWidth(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= 1200) return 1100;
    if (width >= 900) return 860;
    return width;
  }
}
