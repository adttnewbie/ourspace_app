import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/connectivity/connectivity_providers.dart';
import '../../../core/error/app_failure.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/loading_skeleton.dart';
import '../../../shared/widgets/offline_notice.dart';
import '../../../shared/widgets/page_header.dart';
import '../domain/sticky_note.dart';
import 'notes_list_state.dart';
import 'notes_providers.dart';
import 'widgets/confirm_delete_dialog.dart';
import 'widgets/note_editor_dialog.dart';
import 'widgets/notes_empty_card.dart';
import 'widgets/notes_error_card.dart';
import 'widgets/notes_status_pill.dart';
import 'widgets/sticky_note_card.dart';

/// Notes CRUD screen (docs/screen-specs/notes.md, implementation-order §2.4).
class NotesScreen extends ConsumerWidget {
  const NotesScreen({super.key});

  static const _title = 'Notes';
  static const _eyebrow = 'Sticky';
  static const _refreshing = 'Lagi nyegerin data...';
  static const _softWarning = 'Koneksi timeout. Coba lagi.';
  static const _offlineBlocked = 'Butuh internet buat mengubah data.';
  static const _forbidden = 'Ini milik pasanganmu, tidak bisa diubah.';
  static const _notFound = 'Itemnya sudah tidak ada.';
  static const _generic = 'Ada yang error nih';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncNotes = ref.watch(notesListProvider);
    final online = ref.watch(isOnlineProvider);

    return asyncNotes.when(
      loading: () => _NotesScaffold(
        online: online,
        onCreate: () => _openCreate(context, ref),
        body: const NotesSkeleton(),
      ),
      error: (error, _) {
        final offlineNoCache =
            !online &&
            (error is NetworkFailure && error.code == 'NETWORK_OFFLINE');
        if (offlineNoCache) {
          return _NotesScaffold(
            online: online,
            onCreate: () => _openCreate(context, ref),
            body: const OfflineEmptyState(),
          );
        }
        return _NotesScaffold(
          online: online,
          onCreate: () => _openCreate(context, ref),
          body: NotesErrorCard(
            onRetry: () => ref.read(notesListProvider.notifier).refresh(),
          ),
        );
      },
      data: (view) => _NotesBody(view: view, online: online),
    );
  }

  static Future<void> _openCreate(BuildContext context, WidgetRef ref) async {
    final online = ref.read(isOnlineProvider);
    if (!online) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(_offlineBlocked)),
      );
      return;
    }
    ref.read(noteEditorControllerProvider.notifier).startCreate();
    await showNoteEditorDialog(context, ref);
  }
}

class _NotesBody extends ConsumerWidget {
  const _NotesBody({required this.view, required this.online});

  final NotesListViewState view;
  final bool online;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = view.items;
    final showOfflineBanner = !online;
    final showRefreshing = view.isRefreshing;
    final showSoftWarning = view.softWarning && !view.isRefreshing;

    return RefreshIndicator(
      onRefresh: () => ref.read(notesListProvider.notifier).refresh(),
      child: _NotesScaffold(
        online: online,
        onCreate: () => NotesScreen._openCreate(context, ref),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (showOfflineBanner) const OfflineNotice(),
            if (showRefreshing)
              const NotesStatusPill(label: NotesScreen._refreshing),
            if (showSoftWarning)
              const NotesStatusPill(label: NotesScreen._softWarning),
            if (items.isEmpty)
              NotesEmptyCard(
                onAdd: () => NotesScreen._openCreate(context, ref),
              )
            else
              for (final note in items) ...[
                StickyNoteCard(
                  note: note,
                  onEdit: note.canEdit
                      ? () => _openEdit(context, ref, note)
                      : null,
                  onDelete: note.canEdit
                      ? () => _confirmDelete(context, ref, note)
                      : null,
                ),
                const SizedBox(height: AppSpacing.x4),
              ],
            const SizedBox(height: AppSpacing.contentClearance),
          ],
        ),
      ),
    );
  }

  Future<void> _openEdit(
    BuildContext context,
    WidgetRef ref,
    StickyNote note,
  ) async {
    if (!online) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(NotesScreen._offlineBlocked)),
      );
      return;
    }
    ref.read(noteEditorControllerProvider.notifier).startEdit(note);
    await showNoteEditorDialog(context, ref);
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    StickyNote note,
  ) async {
    if (!online) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(NotesScreen._offlineBlocked)),
      );
      return;
    }
    final confirmed = await showConfirmDeleteNoteDialog(context);
    if (!confirmed || !context.mounted) return;

    try {
      await ref.read(notesListProvider.notifier).remove(id: note.id);
    } on AppFailure catch (e) {
      if (!context.mounted) return;
      final message = switch (e.code) {
        'OFFLINE_MUTATION_BLOCKED' => NotesScreen._offlineBlocked,
        'FORBIDDEN' => NotesScreen._forbidden,
        'NOT_FOUND' => NotesScreen._notFound,
        _ => e.message ?? NotesScreen._generic,
      };
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
      if (e.code == 'FORBIDDEN' || e.code == 'NOT_FOUND') {
        await ref.read(notesListProvider.notifier).refresh();
      }
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(NotesScreen._generic)),
      );
    }
  }
}

class _NotesScaffold extends StatelessWidget {
  const _NotesScaffold({
    required this.online,
    required this.onCreate,
    required this.body,
  });

  final bool online;
  final VoidCallback onCreate;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.x4,
            AppSpacing.x4,
            AppSpacing.x4,
            AppSpacing.x4,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                PageHeader(
                  title: NotesScreen._title,
                  eyebrow: NotesScreen._eyebrow,
                  action: AppButton(
                    icon: const Icon(Icons.add, size: 20),
                    semanticLabel: 'Tambah note',
                    onPressed: onCreate,
                    size: AppButtonSize.icon,
                  ),
                ),
                body,
              ],
            ),
          ),
        );
      },
    );
  }
}
