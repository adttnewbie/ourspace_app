import 'dart:convert';

import '../../notes/data/sticky_note_dto.dart';
import '../../notes/domain/sticky_note.dart';
import '../domain/home_snapshot.dart';

/// Parses only documented `home.get` data fields (api-contract.md).
abstract final class HomeDto {
  static const cacheKey = 'home.get';

  static HomeSnapshot fromGetData(
    Map<String, dynamic> data, {
    required DateTime fetchedAt,
    bool fromCache = false,
  }) {
    final greeting = data['greeting'];
    final anniversaryRaw = data['anniversaryDate'];
    final daysTogetherRaw = data['daysTogether'];
    final todayRaw = data['today'];
    final countsRaw = data['counts'];

    if (greeting is! String) {
      throw const FormatException('home.get missing greeting');
    }
    if (anniversaryRaw is! String || anniversaryRaw.isEmpty) {
      throw const FormatException('home.get missing anniversaryDate');
    }
    if (daysTogetherRaw is! num) {
      throw const FormatException('home.get missing daysTogether');
    }

    final todayStickyNotes = <StickyNote>[];
    if (todayRaw is Map) {
      final stickyRaw = todayRaw['stickyNotes'];
      if (stickyRaw is List) {
        for (final item in stickyRaw) {
          if (item is Map) {
            todayStickyNotes.add(
              StickyNoteDto.fromMap(Map<String, dynamic>.from(item)),
            );
          }
        }
      }
    }

    var stickyNotesCount = 0;
    if (countsRaw is Map && countsRaw['stickyNotes'] is num) {
      stickyNotesCount = (countsRaw['stickyNotes'] as num).toInt();
    }

    return HomeSnapshot(
      greeting: greeting,
      anniversaryDate: DateTime.parse(anniversaryRaw),
      daysTogether: daysTogetherRaw.toInt(),
      todayStickyNotes: todayStickyNotes,
      stickyNotesCount: stickyNotesCount,
      fetchedAt: fetchedAt,
      fromCache: fromCache,
    );
  }

  /// Serializes API payload + metadata for CacheStore (API data only).
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

  static ({HomeSnapshot snapshot, DateTime fetchedAt})? decodeCacheEntry(
    String raw,
  ) {
    final decoded = jsonDecode(raw);
    if (decoded is! Map) return null;
    final map = Map<String, dynamic>.from(decoded);
    final fetchedAtRaw = map['fetchedAt'];
    final payload = map['payload'];
    if (fetchedAtRaw is! String || payload is! Map) return null;
    final fetchedAt = DateTime.parse(fetchedAtRaw);
    final snapshot = fromGetData(
      Map<String, dynamic>.from(payload),
      fetchedAt: fetchedAt,
      fromCache: true,
    );
    return (snapshot: snapshot, fetchedAt: fetchedAt);
  }
}
