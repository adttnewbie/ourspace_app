import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';

/// Title block + pink→yellow underline (design.md §12 / §3 PageHeader).
class PageHeader extends StatelessWidget {
  const PageHeader({super.key, required this.title, this.eyebrow, this.action});

  final String title;
  final String? eyebrow;

  /// Optional trailing control (e.g. page create action).
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.x4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (eyebrow != null) ...[
                  Text(
                    eyebrow!,
                    style: textTheme.labelSmall?.copyWith(
                      color: AppColors.mutedForeground,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x2),
                ],
                Text(
                  title,
                  style: textTheme.displaySmall?.copyWith(
                    color: AppColors.foreground,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: AppSpacing.x2),
                const _UnderlineBar(),
              ],
            ),
          ),
          if (action != null) ...[
            const SizedBox(width: AppSpacing.x3),
            action!,
          ],
        ],
      ),
    );
  }
}

class _UnderlineBar extends StatelessWidget {
  const _UnderlineBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 4,
      width: 72,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.scrapYellow],
        ),
      ),
    );
  }
}
