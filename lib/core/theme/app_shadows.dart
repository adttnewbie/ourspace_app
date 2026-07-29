import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Named paper / glow shadows from [design.md] §9.
class AppShadows {
  AppShadows._();

  /// Soft card — ScrapbookCard, notes, toasts (blur 30, y 10, α 0.10).
  static List<BoxShadow> get softCard => [
    BoxShadow(
      color: AppColors.shadowInk(0.10),
      blurRadius: 30,
      offset: const Offset(0, 10),
    ),
  ];

  /// Soft compact — swatches, active nav, select (blur 18, y 8, α 0.10).
  static List<BoxShadow> get softCompact => [
    BoxShadow(
      color: AppColors.shadowInk(0.10),
      blurRadius: 18,
      offset: const Offset(0, 8),
    ),
  ];

  /// Tape accents (blur 18, y 7, α 0.10).
  static List<BoxShadow> get tape => [
    BoxShadow(
      color: AppColors.shadowInk(0.10),
      blurRadius: 18,
      offset: const Offset(0, 7),
    ),
  ];

  /// Lifted panel — pairing, session gate (blur 45, y 18, α 0.15).
  static List<BoxShadow> get lifted => [
    BoxShadow(
      color: AppColors.shadowInk(0.15),
      blurRadius: 45,
      offset: const Offset(0, 18),
    ),
  ];

  /// App shell on wide screens (blur 80, y 24, α 0.14).
  static List<BoxShadow> get appShell => [
    BoxShadow(
      color: AppColors.shadowInk(0.14),
      blurRadius: 80,
      offset: const Offset(0, 24),
    ),
  ];

  /// Bottom nav upward (blur 40, y -18, α 0.14).
  static List<BoxShadow> get bottomNav => [
    BoxShadow(
      color: AppColors.shadowInk(0.14),
      blurRadius: 40,
      offset: const Offset(0, -18),
    ),
  ];

  /// Offline banner (blur 22, y 8, α 0.10).
  static List<BoxShadow> get offlineBanner => [
    BoxShadow(
      color: AppColors.shadowInk(0.10),
      blurRadius: 22,
      offset: const Offset(0, 8),
    ),
  ];

  /// Card press lift (blur 34, y 16, α 0.16).
  static List<BoxShadow> get cardPress => [
    BoxShadow(
      color: AppColors.shadowInk(0.16),
      blurRadius: 34,
      offset: const Offset(0, 16),
    ),
  ];

  /// Page action pink glow (blur 24, y 10, α 0.28).
  static List<BoxShadow> get pageAction => [
    BoxShadow(
      color: AppColors.primaryGlow(0.28),
      blurRadius: 24,
      offset: const Offset(0, 10),
    ),
  ];

  /// Hold button pink glow (blur 45, y 18, α 0.35).
  static List<BoxShadow> get hold => [
    BoxShadow(
      color: AppColors.primaryGlow(0.35),
      blurRadius: 45,
      offset: const Offset(0, 18),
    ),
  ];
}
