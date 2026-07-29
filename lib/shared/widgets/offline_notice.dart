import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radii.dart';
import '../../core/theme/app_shadows.dart';
import '../../core/theme/app_spacing.dart';
import 'scrapbook_card.dart';

/// Banner when offline with cached content (design.md §12, offline.md).
///
/// Copy: `offline.notice` — docs/copy-catalog.md.
class OfflineNotice extends StatelessWidget {
  const OfflineNotice({super.key});

  static const String noticeText = 'Lagi offline. Menampilkan data terakhir.';

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Semantics(
      liveRegion: true,
      label: noticeText,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: AppSpacing.x3),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x4,
          vertical: AppSpacing.x3,
        ),
        decoration: BoxDecoration(
          color: AppColors.scrapYellow,
          borderRadius: BorderRadius.circular(AppRadii.xl),
          border: Border.all(color: AppColors.border),
          boxShadow: AppShadows.offlineBanner,
        ),
        child: Row(
          children: [
            Icon(LucideIcons.cloudOff, size: 18, color: AppColors.foreground),
            const SizedBox(width: AppSpacing.x2),
            Expanded(
              child: Text(
                noticeText,
                style: textTheme.labelLarge?.copyWith(
                  color: AppColors.foreground,
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// No-cache offline empty (design.md OfflineEmptyState).
///
/// Copy: `offline.empty_title` / `offline.empty_body` — docs/copy-catalog.md.
class OfflineEmptyState extends StatelessWidget {
  const OfflineEmptyState({super.key});

  static const String titleText = 'Belum ada data di HP ini';
  static const String bodyText = 'Sambungkan internet dulu biar bisa muat.';

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return ScrapbookCard(
      tone: ScrapTone.yellow,
      tape: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titleText,
            style: textTheme.headlineSmall?.copyWith(
              color: AppColors.foreground,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(
            bodyText,
            style: textTheme.bodyMedium?.copyWith(
              color: AppColors.mutedForeground,
              fontWeight: FontWeight.w700,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
