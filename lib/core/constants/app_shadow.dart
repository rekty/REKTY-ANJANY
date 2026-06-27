import 'package:flutter/material.dart';

import 'app_colors.dart';

/// ===========================================================================
/// REKTY ANJANY DESIGN SYSTEM
/// APP SHADOW
/// ===========================================================================

class AppShadow {
  AppShadow._();

  // ==========================================================================
  // SOFT SHADOW
  // ==========================================================================

  static const List<BoxShadow> soft = [
    BoxShadow(
      color: Color(0x22000000),
      blurRadius: 12,
      offset: Offset(0, 4),
    ),
  ];

  // ==========================================================================
  // MEDIUM SHADOW
  // ==========================================================================

  static const List<BoxShadow> medium = [
    BoxShadow(
      color: Color(0x33000000),
      blurRadius: 20,
      offset: Offset(0, 8),
    ),
  ];

  // ==========================================================================
  // LARGE SHADOW
  // ==========================================================================

  static const List<BoxShadow> large = [
    BoxShadow(
      color: Color(0x44000000),
      blurRadius: 32,
      offset: Offset(0, 16),
    ),
  ];

  // ==========================================================================
  // CYAN GLOW
  // ==========================================================================

  static const List<BoxShadow> cyanGlow = [
    BoxShadow(
      color: Color(0x6600E5FF),
      blurRadius: 20,
      spreadRadius: 1,
    ),
  ];

  // ==========================================================================
  // STRONG CYAN GLOW
  // ==========================================================================

  static const List<BoxShadow> cyanGlowStrong = [
    BoxShadow(
      color: Color(0x9900E5FF),
      blurRadius: 36,
      spreadRadius: 2,
    ),
  ];

  // ==========================================================================
  // CARD
  // ==========================================================================

  static const List<BoxShadow> card = [
    BoxShadow(
      color: Color(0x22000000),
      blurRadius: 16,
      offset: Offset(0, 8),
    ),
  ];

  // ==========================================================================
  // GLASS CARD
  // ==========================================================================

  static const List<BoxShadow> glass = [
    BoxShadow(
      color: Color(0x11000000),
      blurRadius: 30,
      offset: Offset(0, 10),
    ),
  ];

  // ==========================================================================
  // BUTTON
  // ==========================================================================

  static const List<BoxShadow> button = [
    BoxShadow(
      color: Color(0x4400E5FF),
      blurRadius: 16,
      spreadRadius: 1,
      offset: Offset(0, 6),
    ),
  ];

  // ==========================================================================
  // HOVER
  // ==========================================================================

  static const List<BoxShadow> hover = [
    BoxShadow(
      color: Color(0x7700E5FF),
      blurRadius: 24,
      spreadRadius: 2,
    ),
  ];

  // ==========================================================================
  // NAVBAR
  // ==========================================================================

  static const List<BoxShadow> navbar = [
    BoxShadow(
      color: Color(0x22000000),
      blurRadius: 18,
      offset: Offset(0, 4),
    ),
  ];

  // ==========================================================================
  // DIALOG
  // ==========================================================================

  static const List<BoxShadow> dialog = [
    BoxShadow(
      color: Color(0x55000000),
      blurRadius: 40,
      offset: Offset(0, 20),
    ),
  ];

  // ==========================================================================
  // CUSTOM GLOW
  // ==========================================================================

  static List<BoxShadow> glow({
    Color color = AppColors.primary,
    double blur = 20,
    double spread = 1,
  }) {
    return [
      BoxShadow(
        color: color.withValues(alpha: 0.45),
        blurRadius: blur,
        spreadRadius: spread,
      ),
    ];
  }
}