import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/scrapbook_card.dart';

/// Tappable summary entry (docs/screen-specs/home.md, ui-direction.md).
class SummaryCard extends StatelessWidget {
  const SummaryCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.tone,
    required this.onTap,
  });

  final String title;
  final String description;
  final IconData icon;
  final ScrapTone tone;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Semantics(
      button: true,
      label: title,
      child: ScrapbookCard(
        tone: tone,
        onTap: onTap,
        padding: const EdgeInsets.all(AppSpacing.x4),
        child: Row(
          children: [
            Icon(icon, size: 28, color: AppColors.foreground),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: textTheme.titleMedium?.copyWith(
                      color: AppColors.foreground,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x1),
                  Text(
                    description,
                    style: textTheme.bodySmall?.copyWith(
                      color: AppColors.mutedForeground,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
