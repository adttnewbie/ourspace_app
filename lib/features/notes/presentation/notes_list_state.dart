import '../domain/notes_repository.dart';
import '../domain/sticky_note.dart';

/// UI-facing notes list state (state-management.md §7, screen-specs/notes.md).
class NotesListViewState {
  const NotesListViewState({
    required this.result,
    this.isRefreshing = false,
    this.softWarning = false,
  });

  final NotesListResult result;
  final bool isRefreshing;
  final bool softWarning;

  List<StickyNote> get items => result.items;

  NotesListViewState copyWith({
    NotesListResult? result,
    bool? isRefreshing,
    bool? softWarning,
  }) {
    return NotesListViewState(
      result: result ?? this.result,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      softWarning: softWarning ?? this.softWarning,
    );
  }
}

/// Ephemeral editor draft (docs/state-management.md noteEditorControllerProvider).
class NoteEditorState {
  const NoteEditorState({
    this.noteId,
    this.body = '',
    this.color = 'pink',
    this.isSubmitting = false,
  });

  /// Null = create mode.
  final String? noteId;
  final String body;
  final String color;
  final bool isSubmitting;

  bool get isEdit => noteId != null;

  NoteEditorState copyWith({
    String? noteId,
    String? body,
    String? color,
    bool? isSubmitting,
    bool clearNoteId = false,
  }) {
    return NoteEditorState(
      noteId: clearNoteId ? null : (noteId ?? this.noteId),
      body: body ?? this.body,
      color: color ?? this.color,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }
}
