import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import 'app_button.dart';
import 'app_text_field.dart';
import 'loading_skeleton.dart';
import 'offline_notice.dart';
import 'page_header.dart';
import 'scrapbook_card.dart';

/// Dev-only gallery of shared chrome (implementation-order 1.4 DoD).
class SharedWidgetsGallery extends StatelessWidget {
  const SharedWidgetsGallery({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: AppSpacing.phoneMaxWidth,
            ),
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.x6),
              children: [
                const PageHeader(eyebrow: 'SHARED', title: 'Widgets'),
                const OfflineNotice(),
                const SizedBox(height: AppSpacing.x4),
                Text('ScrapbookCard tones', style: textTheme.titleMedium),
                const SizedBox(height: AppSpacing.x3),
                const ScrapbookCard(
                  tone: ScrapTone.white,
                  child: Text('white'),
                ),
                const SizedBox(height: AppSpacing.x3),
                const ScrapbookCard(
                  tone: ScrapTone.pink,
                  tape: true,
                  child: Text('pink + tape'),
                ),
                const SizedBox(height: AppSpacing.x3),
                const ScrapbookCard(tone: ScrapTone.mint, child: Text('mint')),
                const SizedBox(height: AppSpacing.x3),
                const ScrapbookCard(
                  tone: ScrapTone.yellow,
                  child: Text('yellow'),
                ),
                const SizedBox(height: AppSpacing.x3),
                const ScrapbookCard(tone: ScrapTone.blue, child: Text('blue')),
                const SizedBox(height: AppSpacing.x3),
                const ScrapbookCard(
                  tone: ScrapTone.lavender,
                  child: Text('lavender'),
                ),
                const SizedBox(height: AppSpacing.x6),
                Text('AppButton', style: textTheme.titleMedium),
                const SizedBox(height: AppSpacing.x3),
                AppButton(label: 'Primary', onPressed: () {}, expanded: true),
                const SizedBox(height: AppSpacing.x2),
                AppButton(
                  label: 'Secondary',
                  variant: AppButtonVariant.secondary,
                  onPressed: () {},
                  expanded: true,
                ),
                const SizedBox(height: AppSpacing.x2),
                AppButton(
                  label: 'Outline',
                  variant: AppButtonVariant.outline,
                  onPressed: () {},
                  expanded: true,
                ),
                const SizedBox(height: AppSpacing.x2),
                AppButton(
                  label: 'Destructive',
                  variant: AppButtonVariant.destructive,
                  onPressed: () {},
                  expanded: true,
                ),
                const SizedBox(height: AppSpacing.x6),
                Text('AppTextField', style: textTheme.titleMedium),
                const SizedBox(height: AppSpacing.x3),
                const AppTextField(
                  label: 'Nickname',
                  hintText: 'Nama panggilan',
                ),
                const SizedBox(height: AppSpacing.x6),
                Text('OfflineEmptyState', style: textTheme.titleMedium),
                const SizedBox(height: AppSpacing.x3),
                const OfflineEmptyState(),
                const SizedBox(height: AppSpacing.x6),
                Text('Skeletons', style: textTheme.titleMedium),
                const SizedBox(height: AppSpacing.x3),
                const HomeSkeleton(),
                const SizedBox(height: AppSpacing.x4),
                const NotesSkeleton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
