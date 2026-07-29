import 'package:flutter/material.dart';

import 'app_colors.dart';

/// [ThemeExtension] for scrap accents (design.md §18).
@immutable
class ScrapbookColors extends ThemeExtension<ScrapbookColors> {
  const ScrapbookColors({
    required this.pink,
    required this.mint,
    required this.yellow,
    required this.blue,
    required this.lavender,
  });

  final Color pink;
  final Color mint;
  final Color yellow;
  final Color blue;
  final Color lavender;

  static const ScrapbookColors light = ScrapbookColors(
    pink: AppColors.scrapPink,
    mint: AppColors.scrapMint,
    yellow: AppColors.scrapYellow,
    blue: AppColors.scrapBlue,
    lavender: AppColors.scrapLavender,
  );

  /// Dark scrap accents not fully specified in design.md § gap table;
  /// light scrap reused until product enables dark + defines dark scrap.
  static const ScrapbookColors dark = light;

  @override
  ScrapbookColors copyWith({
    Color? pink,
    Color? mint,
    Color? yellow,
    Color? blue,
    Color? lavender,
  }) {
    return ScrapbookColors(
      pink: pink ?? this.pink,
      mint: mint ?? this.mint,
      yellow: yellow ?? this.yellow,
      blue: blue ?? this.blue,
      lavender: lavender ?? this.lavender,
    );
  }

  @override
  ScrapbookColors lerp(ThemeExtension<ScrapbookColors>? other, double t) {
    if (other is! ScrapbookColors) return this;
    return ScrapbookColors(
      pink: Color.lerp(pink, other.pink, t)!,
      mint: Color.lerp(mint, other.mint, t)!,
      yellow: Color.lerp(yellow, other.yellow, t)!,
      blue: Color.lerp(blue, other.blue, t)!,
      lavender: Color.lerp(lavender, other.lavender, t)!,
    );
  }
}

extension ScrapbookColorsX on BuildContext {
  ScrapbookColors get scrapbookColors =>
      Theme.of(this).extension<ScrapbookColors>() ?? ScrapbookColors.light;
}
