import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/scrapbook_card.dart';

/// Notes load error (copy-catalog notes.error_* / notes.retry).
class NotesErrorCard extends StatelessWidget {
  const NotesErrorCard({super.key, required this.onRetry});

  final VoidCallback onRetry;

  static const _title = 'Notes belum kebuka';
  static const _body = 'Ada gangguan. Coba muat ulang ya.';
  static const _retry = 'Coba lagi';

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return ScrapbookCard(
      tone: ScrapTone.pink,
      tape: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            _title,
            style: textTheme.headlineSmall?.copyWith(
              color: AppColors.foreground,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(
            _body,
            style: textTheme.bodyMedium?.copyWith(
              color: AppColors.mutedForeground,
              fontWeight: FontWeight.w700,
              height: 1.5,
            ),
          ),
          const SizedBox(height: AppSpacing.x5),
          AppButton(label: _retry, onPressed: onRetry, expanded: true),
        ],
      ),
    );
  }
}
