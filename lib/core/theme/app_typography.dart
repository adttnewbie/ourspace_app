import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Type roles from [design.md] §5.
///
/// Single primary family: **Nunito** (warm scrapbook sans from the documented
/// choices: Inter, Nunito, Plus Jakarta Sans).
class AppTypography {
  AppTypography._();

  static String get fontFamily => GoogleFonts.nunito().fontFamily!;

  static TextTheme textTheme({
    required Color foreground,
    required Color mutedForeground,
  }) {
    final base = GoogleFonts.nunitoTextTheme();

    return base.copyWith(
      // Eyebrow — 12–13 sp extrabold
      labelSmall:
          base.labelSmall?.copyWith(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: mutedForeground,
            height: 1.3,
          ) ??
          TextStyle(
            fontFamily: fontFamily,
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: mutedForeground,
            height: 1.3,
          ),
      // Page title — ~36 sp black (900)
      displaySmall:
          base.displaySmall?.copyWith(
            fontSize: 36,
            fontWeight: FontWeight.w900,
            color: foreground,
            height: 1.15,
          ) ??
          TextStyle(
            fontFamily: fontFamily,
            fontSize: 36,
            fontWeight: FontWeight.w900,
            color: foreground,
            height: 1.15,
          ),
      // Section H2 — ~22 sp black/extrabold (mid of 20–24)
      headlineSmall:
          base.headlineSmall?.copyWith(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: foreground,
            height: 1.2,
          ) ??
          TextStyle(
            fontFamily: fontFamily,
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: foreground,
            height: 1.2,
          ),
      // Card title — 17 sp extrabold (mid of 16–18)
      titleMedium:
          base.titleMedium?.copyWith(
            fontSize: 17,
            fontWeight: FontWeight.w800,
            color: foreground,
            height: 1.25,
          ) ??
          TextStyle(
            fontFamily: fontFamily,
            fontSize: 17,
            fontWeight: FontWeight.w800,
            color: foreground,
            height: 1.25,
          ),
      // Body — 14 sp bold/medium, relaxed ~1.5
      bodyMedium:
          base.bodyMedium?.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: foreground,
            height: 1.5,
          ) ??
          TextStyle(
            fontFamily: fontFamily,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: foreground,
            height: 1.5,
          ),
      bodyLarge:
          base.bodyLarge?.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: foreground,
            height: 1.5,
          ) ??
          TextStyle(
            fontFamily: fontFamily,
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: foreground,
            height: 1.5,
          ),
      // Meta — 12–13 sp bold
      bodySmall:
          base.bodySmall?.copyWith(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: mutedForeground,
            height: 1.35,
          ) ??
          TextStyle(
            fontFamily: fontFamily,
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: mutedForeground,
            height: 1.35,
          ),
      // Nav label — 11 sp extrabold
      labelMedium:
          base.labelMedium?.copyWith(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            color: foreground,
            height: 1.2,
          ) ??
          TextStyle(
            fontFamily: fontFamily,
            fontSize: 11,
            fontWeight: FontWeight.w800,
            color: foreground,
            height: 1.2,
          ),
      // Micro / badge — 12 sp medium
      labelLarge:
          base.labelLarge?.copyWith(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: foreground,
            height: 1.2,
          ) ??
          TextStyle(
            fontFamily: fontFamily,
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: foreground,
            height: 1.2,
          ),
    );
  }

  static TextTheme lightTextTheme() => textTheme(
    foreground: AppColors.foreground,
    mutedForeground: AppColors.mutedForeground,
  );

  static TextTheme darkTextTheme() => textTheme(
    foreground: AppColors.foregroundDark,
    mutedForeground: AppColors.mutedForegroundDark,
  );
}
