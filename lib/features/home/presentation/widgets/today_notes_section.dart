import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/scrapbook_card.dart';
import '../../../notes/domain/sticky_note.dart';

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
    final tone = _toneFor(note.color);
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

  static ScrapTone _toneFor(String color) {
    switch (color) {
      case 'pink':
        return ScrapTone.pink;
      case 'mint':
        return ScrapTone.mint;
      case 'blue':
        return ScrapTone.blue;
      case 'lavender':
        return ScrapTone.lavender;
      case 'yellow':
      default:
        return ScrapTone.yellow;
    }
  }
}

/// Color swatch circle (screen-specs/home.md a11y “Warna pink”).
class NoteColorSwatch extends StatelessWidget {
  const NoteColorSwatch({
    super.key,
    required this.colorKey,
    required this.selected,
    required this.onTap,
  });

  final String colorKey;
  final bool selected;
  final VoidCallback onTap;

  static const keys = <String>['yellow', 'pink', 'mint', 'blue', 'lavender'];

  @override
  Widget build(BuildContext context) {
    final tone = switch (colorKey) {
      'pink' => ScrapTone.pink,
      'mint' => ScrapTone.mint,
      'blue' => ScrapTone.blue,
      'lavender' => ScrapTone.lavender,
      _ => ScrapTone.yellow,
    };
    return Semantics(
      button: true,
      selected: selected,
      label: 'Warna $colorKey',
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: tone.backgroundColor(),
            border: Border.all(
              color: selected ? AppColors.ring : AppColors.border,
              width: selected ? 2.5 : 1,
            ),
          ),
        ),
      ),
    );
  }
}
