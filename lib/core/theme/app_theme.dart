import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_colors.dart';
import 'app_radii.dart';
import 'app_typography.dart';
import 'scrapbook_colors.dart';

/// [ThemeData] light/dark from design tokens (design.md §18).
class AppTheme {
  AppTheme._();

  static ThemeData light() {
    final colorScheme = ColorScheme.light(
      primary: AppColors.primary,
      onPrimary: AppColors.primaryForeground,
      primaryContainer: AppColors.scrapPink,
      onPrimaryContainer: AppColors.foreground,
      secondary: AppColors.secondary,
      onSecondary: AppColors.secondaryForeground,
      secondaryContainer: AppColors.muted,
      onSecondaryContainer: AppColors.foreground,
      tertiary: AppColors.accent,
      onTertiary: AppColors.accentForeground,
      error: AppColors.destructive,
      onError: AppColors.destructiveForeground,
      surface: AppColors.card,
      onSurface: AppColors.cardForeground,
      surfaceContainerHighest: AppColors.muted,
      onSurfaceVariant: AppColors.mutedForeground,
      outline: AppColors.border,
      outlineVariant: AppColors.border,
      shadow: AppColors.shadowInk(1),
      scrim: AppColors.dialogScrim,
    );

    final textTheme = AppTypography.lightTextTheme();

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.background,
      canvasColor: AppColors.background,
      cardColor: AppColors.card,
      dividerColor: AppColors.border,
      textTheme: textTheme,
      primaryTextTheme: textTheme,
      fontFamily: AppTypography.fontFamily,
      extensions: const <ThemeExtension<dynamic>>[ScrapbookColors.light],
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.foreground,
        elevation: 0,
        scrolledUnderElevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark.copyWith(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: AppColors.background,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.primaryForeground,
          minimumSize: const Size(40, 40),
          shape: RoundedRectangleBorder(borderRadius: AppRadii.pillBorder),
          textStyle: textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.foreground,
          minimumSize: const Size(40, 40),
          side: const BorderSide(color: AppColors.border),
          shape: RoundedRectangleBorder(borderRadius: AppRadii.pillBorder),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.input,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.innerPanel),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.innerPanel),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.innerPanel),
          borderSide: const BorderSide(color: AppColors.ring, width: 1.5),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.popover,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: AppRadii.dialogBorder),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.card,
        contentTextStyle: textTheme.bodyMedium,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.scrapbookCard),
        ),
        behavior: SnackBarBehavior.floating,
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.border,
        thickness: 1,
      ),
    );
  }

  static ThemeData dark() {
    final colorScheme = ColorScheme.dark(
      primary: AppColors.primaryDark,
      onPrimary: AppColors.primaryForegroundDark,
      secondary: AppColors.secondaryDark,
      onSecondary: AppColors.secondaryForegroundDark,
      tertiary: AppColors.accentDark,
      onTertiary: AppColors.accentForegroundDark,
      error: AppColors.destructiveDark,
      onError: AppColors.destructiveForeground,
      surface: AppColors.cardDark,
      onSurface: AppColors.cardForegroundDark,
      surfaceContainerHighest: AppColors.mutedDark,
      onSurfaceVariant: AppColors.mutedForegroundDark,
      outline: AppColors.borderDark,
      outlineVariant: AppColors.borderDark,
      shadow: AppColors.shadowInk(1),
      scrim: AppColors.dialogScrim,
    );

    final textTheme = AppTypography.darkTextTheme();

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.backgroundDark,
      canvasColor: AppColors.backgroundDark,
      cardColor: AppColors.cardDark,
      dividerColor: AppColors.borderDark,
      textTheme: textTheme,
      primaryTextTheme: textTheme,
      fontFamily: AppTypography.fontFamily,
      extensions: const <ThemeExtension<dynamic>>[ScrapbookColors.dark],
    );
  }
}
