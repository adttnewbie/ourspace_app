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
}
