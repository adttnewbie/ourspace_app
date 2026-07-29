import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/scrapbook_card.dart';

/// Empty notes list (copy-catalog notes.empty_*).
class NotesEmptyCard extends StatelessWidget {
  const NotesEmptyCard({super.key, required this.onAdd});

  final VoidCallback onAdd;

  static const _title = 'Belum ada note';
  static const _body = 'Tulis yang lucu atau yang penting, bebas.';
  static const _cta = 'Tambah note';

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return ScrapbookCard(
      tone: ScrapTone.mint,
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
          AppButton(label: _cta, onPressed: onAdd, expanded: true),
        ],
      ),
    );
  }
}
