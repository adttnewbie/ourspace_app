import 'package:flutter/material.dart';

/// Semantic + scrap accents from [design.md] §4.
/// Only allowed product palette sources.
class AppColors {
  AppColors._();

  // —— Light semantic ——
  static const Color background = Color(0xFFFFF8F1);
  static const Color foreground = Color(0xFF332838);
  static const Color card = Color(0xFFFFFDF8);
  static const Color cardForeground = Color(0xFF332838);
  static const Color popover = Color(0xFFFFFDF8);
  static const Color popoverForeground = Color(0xFF332838);
  static const Color primary = Color(0xFFF16F8F);
  static const Color primaryHover = Color(0xFFE65F82);
  static const Color primaryForeground = Color(0xFFFFFDF8);
  static const Color secondary = Color(0xFFF8EADF);
  static const Color secondaryHover = Color(0xFFF2DED0);
  static const Color secondaryForeground = Color(0xFF332838);
  static const Color muted = Color(0xFFF8EADF);
  static const Color mutedForeground = Color(0xFF7D6975);
  static const Color accent = Color(0xFFFFE89A);
  static const Color accentForeground = Color(0xFF332838);
  static const Color destructive = Color(0xFFD94F5C);
  static const Color destructiveHover = Color(0xFFC94652);
  static const Color destructiveForeground = Color(0xFFFFFDF8);
  static const Color border = Color(0xFFEAD8CF);
  static const Color input = Color(0xFFFFFDF8);
  static const Color ring = Color(0xFF332838);

  // —— Scrap / decorative accents (light) ——
  static const Color scrapPink = Color(0xFFFFD2DF);
  static const Color scrapMint = Color(0xFFBFE8D4);
  static const Color scrapYellow = Color(0xFFFFE89A);
  static const Color scrapBlue = Color(0xFFB9DCFF);
  static const Color scrapLavender = Color(0xFFD9C7FF);

  // —— Dark semantic (parity; ship only if product enables dark) ——
  static const Color backgroundDark = Color(0xFF241F25);
  static const Color foregroundDark = Color(0xFFFFF8F1);
  static const Color cardDark = Color(0xFF2D2730);
  static const Color cardForegroundDark = Color(0xFFFFF8F1);
  static const Color popoverDark = Color(0xFF2D2730);
  static const Color popoverForegroundDark = Color(0xFFFFF8F1);
  static const Color primaryDark = Color(0xFFFF9BB2);
  static const Color primaryForegroundDark = Color(0xFF241F25);
  static const Color secondaryDark = Color(0xFF3B3340);
  static const Color secondaryForegroundDark = Color(0xFFFFF8F1);
  static const Color mutedDark = Color(0xFF3B3340);
  static const Color mutedForegroundDark = Color(0xFFD7C7D0);
  static const Color accentDark = Color(0xFFD7B948);
  static const Color accentForegroundDark = Color(0xFF241F25);
  static const Color destructiveDark = Color(0xFFFF8791);
  static const Color borderDark = Color(0xFF514453);
  static const Color inputDark = Color(0xFF3B3340);
  static const Color ringDark = Color(0xFFFFF8F1);

  /// Warm brown shadow ink RGB (design.md §9 / brand constants).
  static const int shadowInkR = 103;
  static const int shadowInkG = 74;
  static const int shadowInkB = 58;

  /// Primary pink glow RGB (design.md §9 / brand constants).
  static const int primaryGlowR = 241;
  static const int primaryGlowG = 111;
  static const int primaryGlowB = 143;

  static Color shadowInk([double alpha = 1]) =>
      Color.fromRGBO(shadowInkR, shadowInkG, shadowInkB, alpha);

  static Color primaryGlow([double alpha = 1]) =>
      Color.fromRGBO(primaryGlowR, primaryGlowG, primaryGlowB, alpha);

  /// Dialog scrim: black ~30% (design.md §4 overlay).
  static const Color dialogScrim = Color(0x4D000000);
}

/// Scrap tone ids used by ScrapbookCard / notes (design.md §4, §12, §18).
enum ScrapTone { white, pink, mint, yellow, blue, lavender }

extension ScrapToneX on ScrapTone {
  Color backgroundColor() {
    switch (this) {
      case ScrapTone.white:
        return AppColors.card;
      case ScrapTone.pink:
        return AppColors.scrapPink;
      case ScrapTone.mint:
        return AppColors.scrapMint;
      case ScrapTone.yellow:
        return AppColors.scrapYellow;
      case ScrapTone.blue:
        return AppColors.scrapBlue;
      case ScrapTone.lavender:
        return AppColors.scrapLavender;
    }
  }
}
