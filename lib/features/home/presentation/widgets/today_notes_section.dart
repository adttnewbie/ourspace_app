import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/scrapbook_card.dart';
import '../../../notes/domain/sticky_note.dart';
import '../../../notes/presentation/widgets/sticky_note_card.dart';

/// “Terbaru hari ini” — only when non-empty (screen-specs/home.md, api-contract).
class TodayNotesSection extends StatelessWidget {
  const TodayNotesSection({super.key, required this.notes});

  final List<StickyNote> notes;

  static const _title = 'Terbaru hari ini';

  @override
  Widget build(BuildContext context) {
    if (notes.isEmpty) {
      return const SizedBox.shrink();
    }

    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          _title,
          style: textTheme.titleMedium?.copyWith(
            color: AppColors.foreground,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: AppSpacing.x3),
        for (final note in notes) ...[
          _MiniStickyNoteCard(note: note),
          const SizedBox(height: AppSpacing.x3),
        ],
      ],
    );
  }
}

class _MiniStickyNoteCard extends StatelessWidget {
  const _MiniStickyNoteCard({required this.note});

  final StickyNote note;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final tone = scrapToneForColor(note.color);
    return ScrapbookCard(
      tone: tone,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            note.body,
            style: textTheme.bodyMedium?.copyWith(
              color: AppColors.foreground,
              fontWeight: FontWeight.w700,
              height: 1.4,
            ),
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(
            'oleh ${note.createdByNickname}',
            style: textTheme.labelSmall?.copyWith(
              color: AppColors.mutedForeground,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
