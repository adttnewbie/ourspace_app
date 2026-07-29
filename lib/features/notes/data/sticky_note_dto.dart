import 'dart:convert';

import '../domain/notes_repository.dart';
import '../domain/sticky_note.dart';

/// Parses sticky note maps from API (api-contract.md notes.* / home today).
abstract final class StickyNoteDto {
  static const cacheKey = 'notes.list';

  static StickyNote fromMap(Map<String, dynamic> map) {
    final id = map['id'];
    final body = map['body'];
    final color = map['color'];
    final createdBy = map['createdBy'];
    final createdByNickname = map['createdByNickname'];
    final createdAtRaw = map['createdAt'];
    final updatedAtRaw = map['updatedAt'];
    final canEdit = map['canEdit'];

    if (id is! String || id.isEmpty) {
      throw const FormatException('stickyNote.id required');
    }
    if (body is! String) {
      throw const FormatException('stickyNote.body required');
    }
    if (color is! String || color.isEmpty) {
      throw const FormatException('stickyNote.color required');
    }
    if (createdBy is! String) {
      throw const FormatException('stickyNote.createdBy required');
    }
    if (createdByNickname is! String) {
      throw const FormatException('stickyNote.createdByNickname required');
    }
    if (createdAtRaw is! String || createdAtRaw.isEmpty) {
      throw const FormatException('stickyNote.createdAt required');
    }
    if (updatedAtRaw is! String || updatedAtRaw.isEmpty) {
      throw const FormatException('stickyNote.updatedAt required');
    }

    return StickyNote(
      id: id,
      body: body,
      color: color,
      createdBy: createdBy,
      createdByNickname: createdByNickname,
      createdAt: DateTime.parse(createdAtRaw),
      updatedAt: DateTime.parse(updatedAtRaw),
      canEdit: canEdit is bool ? canEdit : false,
    );
  }

  /// Best-effort parse when mutation response includes item fields.
  static StickyNote? tryFromMap(Map<String, dynamic> map) {
    try {
      if (map['id'] is! String) return null;
      return fromMap(map);
    } catch (_) {
      return null;
    }
  }

  static NotesListResult fromListData(
    Map<String, dynamic> data, {
    required DateTime fetchedAt,
    bool fromCache = false,
  }) {
    final itemsRaw = data['items'];
    final items = <StickyNote>[];
    if (itemsRaw is List) {
      for (final item in itemsRaw) {
        if (item is Map) {
          items.add(fromMap(Map<String, dynamic>.from(item)));
        }
      }
    }
    final nextCursorRaw = data['nextCursor'];
    final nextCursor = nextCursorRaw is String && nextCursorRaw.isNotEmpty
        ? nextCursorRaw
        : null;

    return NotesListResult(
      items: items,
      nextCursor: nextCursor,
      fetchedAt: fetchedAt,
      fromCache: fromCache,
    );
  }

  static String encodeCacheEntry({
    required Map<String, dynamic> payload,
    required DateTime fetchedAt,
  }) {
    return jsonEncode(<String, dynamic>{
      'fetchedAt': fetchedAt.toIso8601String(),
      'payload': payload,
      'source': 'network',
    });
  }

  static ({NotesListResult result, DateTime fetchedAt})? decodeCacheEntry(
    String raw,
  ) {
    final decoded = jsonDecode(raw);
    if (decoded is! Map) return null;
    final map = Map<String, dynamic>.from(decoded);
    final fetchedAtRaw = map['fetchedAt'];
    final payload = map['payload'];
    if (fetchedAtRaw is! String || payload is! Map) return null;
    final fetchedAt = DateTime.parse(fetchedAtRaw);
    final result = fromListData(
      Map<String, dynamic>.from(payload),
      fetchedAt: fetchedAt,
      fromCache: true,
    );
    return (result: result, fetchedAt: fetchedAt);
  }
}
