import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radii.dart';
import '../../core/theme/app_spacing.dart';

enum AppButtonVariant { primary, outline, secondary, ghost, destructive, link }

enum AppButtonSize { xs, sm, defaultSize, lg, icon, iconSm, iconLg }

/// Themed action control (design.md §12 AppButton).
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.onPressed,
    this.label,
    this.icon,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.defaultSize,
    this.expanded = false,
    this.isLoading = false,
    this.semanticLabel,
  }) : assert(
         label != null || icon != null,
         'AppButton requires label and/or icon',
       );

  final VoidCallback? onPressed;
  final String? label;
  final Widget? icon;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final bool expanded;
  final bool isLoading;
  final String? semanticLabel;

  bool get _disabled => onPressed == null || isLoading;

  double get _height {
    switch (size) {
      case AppButtonSize.xs:
        return 32;
      case AppButtonSize.sm:
        return 36;
      case AppButtonSize.defaultSize:
        return 40;
      case AppButtonSize.lg:
        return 48;
      case AppButtonSize.iconSm:
        return 36;
      case AppButtonSize.icon:
        return 40;
      case AppButtonSize.iconLg:
        return 48;
    }
  }

  EdgeInsets get _padding {
    switch (size) {
      case AppButtonSize.xs:
        return const EdgeInsets.symmetric(horizontal: AppSpacing.x2);
      case AppButtonSize.sm:
        return const EdgeInsets.symmetric(horizontal: AppSpacing.x3);
      case AppButtonSize.defaultSize:
        return const EdgeInsets.symmetric(horizontal: AppSpacing.x4);
      case AppButtonSize.lg:
        return const EdgeInsets.symmetric(horizontal: AppSpacing.x5);
      case AppButtonSize.iconSm:
      case AppButtonSize.icon:
      case AppButtonSize.iconLg:
        return EdgeInsets.zero;
    }
  }

  bool get _isIconOnly =>
      size == AppButtonSize.icon ||
      size == AppButtonSize.iconSm ||
      size == AppButtonSize.iconLg;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = _colorsFor(variant);

    final child = isLoading
        ? SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: colors.foreground,
            ),
          )
        : _isIconOnly
        ? icon!
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                icon!,
                const SizedBox(width: AppSpacing.x1_5),
              ],
              if (label != null)
                Flexible(
                  child: Text(
                    label!,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.labelLarge?.copyWith(
                      color: colors.foreground,
                      fontWeight: FontWeight.w500,
                      fontSize: size == AppButtonSize.xs ? 12 : 14,
                    ),
                  ),
                ),
            ],
          );

    final shape = RoundedRectangleBorder(
      borderRadius: AppRadii.pillBorder,
      side: colors.border != null
          ? BorderSide(color: colors.border!)
          : BorderSide.none,
    );

    Widget button = Material(
      color: colors.background,
      shape: shape,
      child: InkWell(
        onTap: _disabled ? null : onPressed,
        customBorder: shape,
        focusColor: AppColors.ring.withValues(alpha: 0.08),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: _height,
            minWidth: _isIconOnly ? _height : 40,
          ),
          child: Padding(
            padding: _padding,
            child: Center(child: child),
          ),
        ),
      ),
    );

    if (variant == AppButtonVariant.link) {
      button = TextButton(
        onPressed: _disabled ? null : onPressed,
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          minimumSize: Size(40, _height),
          padding: _padding,
        ),
        child: isLoading
            ? SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.primary,
                ),
              )
            : Text(label ?? ''),
      );
    }

    if (expanded && variant != AppButtonVariant.link) {
      button = SizedBox(width: double.infinity, child: button);
    }

    return Semantics(
      button: true,
      enabled: !_disabled,
      label: semanticLabel ?? label,
      child: Opacity(opacity: _disabled && !isLoading ? 0.5 : 1, child: button),
    );
  }

  _ButtonColors _colorsFor(AppButtonVariant variant) {
    switch (variant) {
      case AppButtonVariant.primary:
        return const _ButtonColors(
          background: AppColors.primary,
          foreground: AppColors.primaryForeground,
        );
      case AppButtonVariant.outline:
        return const _ButtonColors(
          background: AppColors.card,
          foreground: AppColors.foreground,
          border: AppColors.border,
        );
      case AppButtonVariant.secondary:
        return const _ButtonColors(
          background: AppColors.secondary,
          foreground: AppColors.secondaryForeground,
        );
      case AppButtonVariant.ghost:
        return const _ButtonColors(
          background: Colors.transparent,
          foreground: AppColors.foreground,
        );
      case AppButtonVariant.destructive:
        return const _ButtonColors(
          background: AppColors.destructive,
          foreground: AppColors.destructiveForeground,
        );
      case AppButtonVariant.link:
        return const _ButtonColors(
          background: Colors.transparent,
          foreground: AppColors.primary,
        );
    }
  }
}

class _ButtonColors {
  const _ButtonColors({
    required this.background,
    required this.foreground,
    this.border,
  });

  final Color background;
  final Color foreground;
  final Color? border;
}
