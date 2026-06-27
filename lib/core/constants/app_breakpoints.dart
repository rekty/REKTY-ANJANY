import 'package:flutter/material.dart';

/// ===========================================================================
/// REKTY ANJANY DESIGN SYSTEM
/// RESPONSIVE BREAKPOINTS
/// ===========================================================================

class AppBreakpoints {
  AppBreakpoints._();

  /// Mobile
  static const double mobile = 600;

  /// Tablet
  static const double tablet = 1024;

  /// Desktop
  static const double desktop = 1440;

  /// Large Desktop
  static const double largeDesktop = 1920;

  // ==========================================================================
  // DEVICE CHECK
  // ==========================================================================

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < mobile;

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return width >= mobile && width < tablet;
  }

  static bool isDesktop(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return width >= tablet;
  }

  static bool isLargeDesktop(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return width >= largeDesktop;
  }

  // ==========================================================================
  // SCREEN WIDTH
  // ==========================================================================

  static double width(BuildContext context) =>
      MediaQuery.of(context).size.width;

  static double height(BuildContext context) =>
      MediaQuery.of(context).size.height;
}