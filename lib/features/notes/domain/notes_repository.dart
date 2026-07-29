import 'sticky_note.dart';

/// Notes aggregate access (docs/state-management.md §12).
abstract class NotesRepository {
  /// Lists stickies via `notes.list` (api-contract.md). Soft-deleted excluded by server.
  Future<NotesListResult> list({int limit = 50, String? cursor, bool force = false});

  /// Network-only list fetch; writes cache.
  Future<NotesListResult> fetchFresh({int limit = 50, String? cursor});

  /// Last cached list if any (TTL ignored).
  Future<NotesListResult?> readCache();

  /// Creates via `notes.create`. Returns created note when response includes item fields.
  Future<StickyNote?> create({required String body, required String color});

  /// Updates via `notes.update`. Owner only (server `FORBIDDEN`).
  Future<StickyNote?> update({
    required String id,
    required String body,
    required String color,
  });

  /// Soft-deletes via `notes.delete`. Owner only (server `FORBIDDEN`).
  Future<void> delete({required String id});

  /// Clears local notes list cache.
  Future<void> clearCache();
}

/// List payload + cache metadata (state-management.md §4).
class NotesListResult {
  const NotesListResult({
    required this.items,
    this.nextCursor,
    required this.fetchedAt,
    this.fromCache = false,
  });

  final List<StickyNote> items;
  final String? nextCursor;
  final DateTime fetchedAt;
  final bool fromCache;

  NotesListResult copyWith({
    List<StickyNote>? items,
    String? nextCursor,
    DateTime? fetchedAt,
    bool? fromCache,
  }) {
    return NotesListResult(
      items: items ?? this.items,
      nextCursor: nextCursor ?? this.nextCursor,
      fetchedAt: fetchedAt ?? this.fetchedAt,
      fromCache: fromCache ?? this.fromCache,
    );
  }
}
