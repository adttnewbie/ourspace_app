import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';

/// Yellow status pill (design.md §17, shared.refreshing).
class NotesStatusPill extends StatelessWidget {
  const NotesStatusPill({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Semantics(
      liveRegion: true,
      label: label,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: AppSpacing.x3),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x4,
          vertical: AppSpacing.x2,
        ),
        decoration: BoxDecoration(
          color: AppColors.scrapYellow,
          borderRadius: BorderRadius.circular(AppRadii.xl),
          border: Border.all(color: AppColors.border),
        ),
        child: Text(
          label,
          style: textTheme.labelLarge?.copyWith(
            color: AppColors.foreground,
            fontWeight: FontWeight.w800,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
