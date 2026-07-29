import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import 'sticky_note_card.dart';

/// Five scrap color keys (data-model.md, screen-specs/notes.md).
class NoteColorSwatches extends StatelessWidget {
  const NoteColorSwatches({
    super.key,
    required this.selected,
    required this.onSelected,
    this.enabled = true,
  });

  static const keys = <String>['yellow', 'pink', 'mint', 'blue', 'lavender'];

  final String selected;
  final ValueChanged<String> onSelected;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final key in keys) ...[
          _Swatch(
            colorKey: key,
            selected: selected == key,
            onTap: enabled ? () => onSelected(key) : null,
          ),
          if (key != keys.last) const SizedBox(width: AppSpacing.x2),
        ],
      ],
    );
  }
}

class _Swatch extends StatelessWidget {
  const _Swatch({
    required this.colorKey,
    required this.selected,
    required this.onTap,
  });

  final String colorKey;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final tone = scrapToneForColor(colorKey);
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
