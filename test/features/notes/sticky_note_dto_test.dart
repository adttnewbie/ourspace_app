import 'package:flutter_test/flutter_test.dart';
import 'package:ourspace_app/features/notes/data/sticky_note_dto.dart';

void main() {
  group('StickyNoteDto', () {
    final item = <String, dynamic>{
      'id': 'note_123',
      'body': 'Aku kangen es krim kemarin.',
      'color': 'pink',
      'createdBy': 'member_a',
      'createdByNickname': 'Nama Kamu',
      'createdAt': '2026-07-02T08:05:00.000Z',
      'updatedAt': '2026-07-02T08:05:00.000Z',
      'canEdit': true,
    };

    test('fromMap_mapsDocumentedFields', () {
      final note = StickyNoteDto.fromMap(item);
      expect(note.id, 'note_123');
      expect(note.body, 'Aku kangen es krim kemarin.');
      expect(note.color, 'pink');
      expect(note.createdBy, 'member_a');
      expect(note.createdByNickname, 'Nama Kamu');
      expect(note.canEdit, isTrue);
    });

    test('fromListData_mapsItemsAndCursor', () {
      final result = StickyNoteDto.fromListData(
        <String, dynamic>{
          'items': [item],
          'nextCursor': null,
        },
        fetchedAt: DateTime.utc(2026, 7, 2),
      );
      expect(result.items.length, 1);
      expect(result.nextCursor, isNull);
      expect(result.fromCache, isFalse);
    });

    test('cacheRoundTrip_preservesPayload', () {
      final payload = <String, dynamic>{
        'items': [item],
        'nextCursor': null,
      };
      final now = DateTime.utc(2026, 7, 2, 8);
      final raw = StickyNoteDto.encodeCacheEntry(
        payload: payload,
        fetchedAt: now,
      );
      final decoded = StickyNoteDto.decodeCacheEntry(raw);
      expect(decoded, isNotNull);
      expect(decoded!.result.items.single.id, 'note_123');
      expect(decoded.result.fromCache, isTrue);
    });

    test('tryFromMap_empty_returnsNull', () {
      expect(StickyNoteDto.tryFromMap(<String, dynamic>{}), isNull);
    });
  });
}
