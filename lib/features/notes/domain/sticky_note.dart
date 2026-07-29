/// Sticky note entity (docs/data-model.md, api-contract.md notes.*).
class StickyNote {
  const StickyNote({
    required this.id,
    required this.body,
    required this.color,
    required this.createdBy,
    required this.createdByNickname,
    required this.createdAt,
    required this.updatedAt,
    required this.canEdit,
  });

  final String id;
  final String body;

  /// API color key: yellow|pink|mint|blue|lavender.
  final String color;
  final String createdBy;
  final String createdByNickname;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool canEdit;

  StickyNote copyWith({
    String? id,
    String? body,
    String? color,
    String? createdBy,
    String? createdByNickname,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? canEdit,
  }) {
    return StickyNote(
      id: id ?? this.id,
      body: body ?? this.body,
      color: color ?? this.color,
      createdBy: createdBy ?? this.createdBy,
      createdByNickname: createdByNickname ?? this.createdByNickname,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      canEdit: canEdit ?? this.canEdit,
    );
  }
}
