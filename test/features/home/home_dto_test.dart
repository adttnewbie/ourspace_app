import 'package:flutter_test/flutter_test.dart';
import 'package:ourspace_app/features/home/data/home_dto.dart';

void main() {
  group('HomeDto', () {
    test('fromGetData_mapsDocumentedFields', () {
      final snap = HomeDto.fromGetData(
        <String, dynamic>{
          'greeting': 'Hai, Nama Kamu',
          'anniversaryDate': '2026-07-02T08:00:12.000Z',
          'daysTogether': 1,
          'today': {
            'stickyNotes': [
              {
                'id': 'note_123',
                'body': 'Aku kangen es krim kemarin.',
                'color': 'pink',
                'createdBy': 'member_a',
                'createdByNickname': 'Nama Kamu',
                'createdAt': '2026-07-02T08:05:00.000Z',
                'updatedAt': '2026-07-02T08:05:00.000Z',
                'canEdit': true,
              },
            ],
          },
          'counts': {'stickyNotes': 3},
        },
        fetchedAt: DateTime.utc(2026, 7, 2, 9),
      );

      expect(snap.greeting, 'Hai, Nama Kamu');
      expect(snap.daysTogether, 1);
      expect(snap.stickyNotesCount, 3);
      expect(snap.todayStickyNotes, hasLength(1));
      expect(snap.todayStickyNotes.first.id, 'note_123');
      expect(snap.todayStickyNotes.first.color, 'pink');
      expect(snap.fromCache, isFalse);
    });

    test('fromGetData_emptyToday_ok', () {
      final snap = HomeDto.fromGetData(
        <String, dynamic>{
          'greeting': 'Hai',
          'anniversaryDate': '2026-07-02T08:00:12.000Z',
          'daysTogether': 0,
          'today': {'stickyNotes': <dynamic>[]},
          'counts': {'stickyNotes': 0},
        },
        fetchedAt: DateTime.now(),
      );
      expect(snap.todayStickyNotes, isEmpty);
      expect(snap.stickyNotesCount, 0);
    });

    test('cacheRoundTrip_preservesPayload', () {
      final payload = <String, dynamic>{
        'greeting': 'Hai',
        'anniversaryDate': '2026-07-02T08:00:12.000Z',
        'daysTogether': 2,
        'today': {'stickyNotes': <dynamic>[]},
        'counts': {'stickyNotes': 0},
      };
      final fetchedAt = DateTime.utc(2026, 7, 2, 10);
      final raw = HomeDto.encodeCacheEntry(
        payload: payload,
        fetchedAt: fetchedAt,
      );
      final decoded = HomeDto.decodeCacheEntry(raw);
      expect(decoded, isNotNull);
      expect(decoded!.snapshot.greeting, 'Hai');
      expect(decoded.snapshot.daysTogether, 2);
      expect(decoded.snapshot.fromCache, isTrue);
      expect(decoded.fetchedAt.toUtc(), fetchedAt);
    });
  });
}
