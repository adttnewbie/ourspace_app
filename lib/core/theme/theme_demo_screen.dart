import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_radii.dart';
import 'app_shadows.dart';
import 'app_spacing.dart';

/// Temporary demo for step 1.3 DoD: scrap tones + typography.
/// Replaced when shared widgets / routing land (1.4 / 1.8).
class ThemeDemoScreen extends StatelessWidget {
  const ThemeDemoScreen({super.key});

  static const _tones = <(ScrapTone, String)>[
    (ScrapTone.white, 'white'),
    (ScrapTone.pink, 'pink'),
    (ScrapTone.mint, 'mint'),
    (ScrapTone.yellow, 'yellow'),
    (ScrapTone.blue, 'blue'),
    (ScrapTone.lavender, 'lavender'),
  ];

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
                Text('THEME', style: textTheme.labelSmall),
                const SizedBox(height: AppSpacing.x2),
                Text('OurSpace', style: textTheme.displaySmall),
                const SizedBox(height: AppSpacing.x3),
                Text('Section H2', style: textTheme.headlineSmall),
                const SizedBox(height: AppSpacing.x2),
                Text('Card title', style: textTheme.titleMedium),
                const SizedBox(height: AppSpacing.x2),
                Text(
                  'Body — deskripsi scrapbook 14 sp.',
                  style: textTheme.bodyMedium,
                ),
                const SizedBox(height: AppSpacing.x1),
                Text('Meta · author', style: textTheme.bodySmall),
                const SizedBox(height: AppSpacing.x1),
                Text('Nav label', style: textTheme.labelMedium),
                const SizedBox(height: AppSpacing.x1),
                Text('Badge', style: textTheme.labelLarge),
                const SizedBox(height: AppSpacing.x6),
                Text('Scrap tones', style: textTheme.titleMedium),
                const SizedBox(height: AppSpacing.x3),
                Wrap(
                  spacing: AppSpacing.x3,
                  runSpacing: AppSpacing.x3,
                  children: [
                    for (final (tone, label) in _tones)
                      _ToneSwatch(tone: tone, label: label),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ToneSwatch extends StatelessWidget {
  const _ToneSwatch({required this.tone, required this.label});

  final ScrapTone tone;
  final String label;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: 140,
      padding: const EdgeInsets.all(AppSpacing.x4),
      decoration: BoxDecoration(
        color: tone.backgroundColor(),
        borderRadius: AppRadii.scrapbookCardBorder,
        border: Border.all(color: AppColors.border, width: 1),
        boxShadow: AppShadows.softCard,
      ),
      child: Text(label, style: textTheme.titleMedium),
    );
  }
}
