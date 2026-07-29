import '../domain/sticky_note.dart';

/// Parses sticky note maps from API (api-contract.md notes.list / home today).
abstract final class StickyNoteDto {
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
}
