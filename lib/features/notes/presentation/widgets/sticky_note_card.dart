import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/scrapbook_card.dart';
import '../../domain/sticky_note.dart';

/// Sticky list item (docs/screen-specs/notes.md). Edit/delete only if [canEdit].
class StickyNoteCard extends StatelessWidget {
  const StickyNoteCard({
    super.key,
    required this.note,
    this.onEdit,
    this.onDelete,
  });

  final StickyNote note;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  static const _editA11y = 'Edit note';
  static const _deleteA11y = 'Hapus note';

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final tone = scrapToneForColor(note.color);
    final author = note.createdByNickname.trim().isEmpty
        ? 'oleh seseorang'
        : 'oleh ${note.createdByNickname}';
    final excerpt = note.body.length > 80
        ? '${note.body.substring(0, 80)}…'
        : note.body;

    return Semantics(
      label: '$excerpt, $author',
      child: ScrapbookCard(
        tone: tone,
        tape: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              note.body,
              style: textTheme.bodyMedium?.copyWith(
                color: AppColors.foreground,
                fontWeight: FontWeight.w700,
                height: 1.45,
              ),
            ),
            const SizedBox(height: AppSpacing.x3),
            Row(
              children: [
                Expanded(
                  child: Text(
                    author,
                    style: textTheme.labelSmall?.copyWith(
                      color: AppColors.mutedForeground,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                if (note.canEdit) ...[
                  AppButton(
                    icon: const Icon(Icons.edit_outlined, size: 16),
                    semanticLabel: _editA11y,
                    onPressed: onEdit,
                    size: AppButtonSize.iconSm,
                    variant: AppButtonVariant.ghost,
                  ),
                  const SizedBox(width: AppSpacing.x1),
                  AppButton(
                    icon: const Icon(Icons.delete_outline, size: 16),
                    semanticLabel: _deleteA11y,
                    onPressed: onDelete,
                    size: AppButtonSize.iconSm,
                    variant: AppButtonVariant.ghost,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

ScrapTone scrapToneForColor(String color) {
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
