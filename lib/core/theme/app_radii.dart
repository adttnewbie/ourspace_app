import 'package:flutter/material.dart';

/// Border radius tokens from [design.md] §8.
class AppRadii {
  AppRadii._();

  static const double sm = 6;
  static const double md = 10;
  static const double lg = 14;
  static const double xl = 22;
  static const double x2l = 25;
  static const double x3l = 31;
  static const double x4l = 36;

  /// Scrapbook / paper cards, toasts (design.md practical radii).
  static const double scrapbookCard = 28;

  /// Dialog / bottom sheet / pairing shells.
  static const double dialog = 32;

  /// Sticky note home mini.
  static const double stickyNoteHome = 24;

  /// Sticky note articles (notes list).
  static const double stickyNote = 28;

  /// Inner panels / multi-line fields (~18–20 → 18).
  static const double innerPanel = 18;

  /// Nav items (~16–20 → 18).
  static const double navItem = 18;

  /// Pill buttons (full).
  static const double pill = 999;

  static BorderRadius get scrapbookCardBorder =>
      BorderRadius.circular(scrapbookCard);

  static BorderRadius get dialogBorder => BorderRadius.circular(dialog);

  static BorderRadius get pillBorder => BorderRadius.circular(pill);
}
