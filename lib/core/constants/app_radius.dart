import 'package:flutter/material.dart';

/// ===========================================================================
/// REKTY ANJANY DESIGN SYSTEM
/// APP RADIUS
/// ===========================================================================

class AppRadius {
  AppRadius._();

  // Radius Value
  static const double none = 0;
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double round = 999;

  // BorderRadius
  static const BorderRadius noneRadius =
      BorderRadius.all(Radius.circular(none));

  static const BorderRadius xsRadius =
      BorderRadius.all(Radius.circular(xs));

  static const BorderRadius smRadius =
      BorderRadius.all(Radius.circular(sm));

  static const BorderRadius mdRadius =
      BorderRadius.all(Radius.circular(md));

  static const BorderRadius lgRadius =
      BorderRadius.all(Radius.circular(lg));

  static const BorderRadius xlRadius =
      BorderRadius.all(Radius.circular(xl));

  static const BorderRadius xxlRadius =
      BorderRadius.all(Radius.circular(xxl));

  static const BorderRadius roundRadius =
      BorderRadius.all(Radius.circular(round));

  // Card
  static const BorderRadius card = xlRadius;

  // Button
  static const BorderRadius button = lgRadius;

  // Input
  static const BorderRadius input = lgRadius;

  // Dialog
  static const BorderRadius dialog = xxlRadius;

  // Bottom Sheet
  static const BorderRadius bottomSheet = BorderRadius.vertical(
    top: Radius.circular(xxl),
  );

  // Avatar
  static const BorderRadius avatar = roundRadius;
}