import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/scrapbook_card.dart';
import '../../domain/home_snapshot.dart';

/// Greeting + days together (docs/screen-specs/home.md, copy-catalog Home).
class GreetingCard extends StatelessWidget {
  const GreetingCard({super.key, required this.snapshot});

  final HomeSnapshot snapshot;

  static const _greetingFallback = 'Hai';

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final greeting = snapshot.greeting.trim().isEmpty
        ? _greetingFallback
        : snapshot.greeting;
    final daysLabel = '${snapshot.daysTogether} hari bareng';

    return ScrapbookCard(
      tone: ScrapTone.pink,
      tape: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            greeting,
            style: textTheme.headlineSmall?.copyWith(
              color: AppColors.foreground,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(
            daysLabel,
            style: textTheme.titleMedium?.copyWith(
              color: AppColors.mutedForeground,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
