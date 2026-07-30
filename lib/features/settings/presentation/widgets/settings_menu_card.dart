import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/scrapbook_card.dart';

/// Tappable settings row (docs/screen-specs/settings.md SettingsMenuCard).
class SettingsMenuCard extends StatelessWidget {
  const SettingsMenuCard({
    super.key,
    required this.label,
    required this.onTap,
    this.tone = ScrapTone.white,
    this.enabled = true,
    this.isLoading = false,
    this.trailing,
  });

  final String label;
  final VoidCallback? onTap;
  final ScrapTone tone;
  final bool enabled;
  final bool isLoading;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final canTap = enabled && !isLoading && onTap != null;

    return ScrapbookCard(
      tone: tone,
      onTap: canTap ? onTap : null,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x4,
        vertical: AppSpacing.x4,
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 48),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: textTheme.titleSmall?.copyWith(
                  color: canTap
                      ? AppColors.foreground
                      : AppColors.mutedForeground,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            if (isLoading)
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            else if (trailing != null)
              trailing!
            else
              Icon(
                Icons.chevron_right,
                color: canTap
                    ? AppColors.mutedForeground
                    : AppColors.mutedForeground.withValues(alpha: 0.5),
              ),
          ],
        ),
      ),
    );
  }
}
