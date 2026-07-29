import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/app_failure.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../notes_providers.dart';
import 'note_color_swatches.dart';

/// Create/edit sticky dialog (docs/screen-specs/notes.md).
Future<void> showNoteEditorDialog(BuildContext context, WidgetRef ref) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => const _NoteEditorDialogBody(),
  );
}

class _NoteEditorDialogBody extends ConsumerStatefulWidget {
  const _NoteEditorDialogBody();

  @override
  ConsumerState<_NoteEditorDialogBody> createState() =>
      _NoteEditorDialogBodyState();
}

class _NoteEditorDialogBodyState extends ConsumerState<_NoteEditorDialogBody> {
  static const _createTitle = 'Note baru';
  static const _editTitle = 'Edit note';
  static const _hint = 'Isi note…';
  static const _save = 'Simpan';
  static const _cancel = 'Batal';
  static const _closeA11y = 'Tutup dialog';
  static const _offlineBlocked = 'Butuh internet buat mengubah data.';
  static const _forbidden = 'Ini milik pasanganmu, tidak bisa diubah.';
  static const _maxLength = 280;

  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    final initial = ref.read(noteEditorControllerProvider).body;
    _controller = TextEditingController(text: initial);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _onSave() async {
    final editor = ref.read(noteEditorControllerProvider);
    final body = _controller.text.trim();
    if (body.isEmpty || editor.isSubmitting) return;

    final notifier = ref.read(noteEditorControllerProvider.notifier);
    notifier.setBody(body);
    notifier.setSubmitting(true);
    try {
      final list = ref.read(notesListProvider.notifier);
      if (editor.isEdit) {
        await list.updateNote(
          id: editor.noteId!,
          body: body,
          color: editor.color,
        );
      } else {
        await list.create(body: body, color: editor.color);
      }
      if (!mounted) return;
      notifier.reset();
      Navigator.of(context).pop();
    } on AppFailure catch (e) {
      if (!mounted) return;
      notifier.setSubmitting(false);
      final message = switch (e.code) {
        'OFFLINE_MUTATION_BLOCKED' => _offlineBlocked,
        'FORBIDDEN' => _forbidden,
        'CONFLICT' => 'Datanya bentrok. Muat ulang dulu.',
        'NOT_FOUND' => 'Itemnya sudah tidak ada.',
        _ => e.message ?? 'Ada yang error nih',
      };
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
      if (e.code == 'FORBIDDEN' ||
          e.code == 'CONFLICT' ||
          e.code == 'NOT_FOUND') {
        ref.read(notesListProvider.notifier).refresh();
      }
    } catch (_) {
      if (!mounted) return;
      notifier.setSubmitting(false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Ada yang error nih')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final editor = ref.watch(noteEditorControllerProvider);
    final body = _controller.text.trim();
    final canSave = body.isNotEmpty && !editor.isSubmitting;

    return AlertDialog(
      backgroundColor: AppColors.card,
      title: Text(
        editor.isEdit ? _editTitle : _createTitle,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: AppColors.foreground,
          fontWeight: FontWeight.w800,
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            NoteColorSwatches(
              selected: editor.color,
              enabled: !editor.isSubmitting,
              onSelected: (key) =>
                  ref.read(noteEditorControllerProvider.notifier).setColor(key),
            ),
            const SizedBox(height: AppSpacing.x4),
            AppTextField(
              controller: _controller,
              hintText: _hint,
              maxLength: _maxLength,
              enabled: !editor.isSubmitting,
              onChanged: (v) {
                ref.read(noteEditorControllerProvider.notifier).setBody(v);
                setState(() {});
              },
            ),
          ],
        ),
      ),
      actions: [
        AppButton(
          label: _cancel,
          variant: AppButtonVariant.ghost,
          semanticLabel: _closeA11y,
          onPressed: editor.isSubmitting
              ? null
              : () {
                  ref.read(noteEditorControllerProvider.notifier).reset();
                  Navigator.of(context).pop();
                },
        ),
        AppButton(
          label: _save,
          onPressed: canSave ? _onSave : null,
          isLoading: editor.isSubmitting,
        ),
      ],
    );
  }
}
