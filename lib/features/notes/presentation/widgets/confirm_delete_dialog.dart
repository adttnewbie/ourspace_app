import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../shared/widgets/app_button.dart';

/// Soft-delete confirm (copy-catalog notes.delete_*).
Future<bool> showConfirmDeleteNoteDialog(BuildContext context) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: AppColors.card,
      shape: RoundedRectangleBorder(borderRadius: AppRadii.dialogBorder),
      title: Text(
        'Hapus note?',
        style: Theme.of(ctx).textTheme.titleMedium?.copyWith(
          color: AppColors.foreground,
          fontWeight: FontWeight.w800,
        ),
      ),
      content: Text(
        'Note ini dihapus dari daftar (soft delete).',
        style: Theme.of(ctx).textTheme.bodyMedium?.copyWith(
          color: AppColors.mutedForeground,
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: [
        AppButton(
          label: 'Batal',
          semanticLabel: 'Tutup dialog',
          variant: AppButtonVariant.ghost,
          onPressed: () => Navigator.of(ctx).pop(false),
        ),
        AppButton(
          label: 'Hapus',
          variant: AppButtonVariant.destructive,
          onPressed: () => Navigator.of(ctx).pop(true),
        ),
      ],
    ),
  );
  return result ?? false;
}
