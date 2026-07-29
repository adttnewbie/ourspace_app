import '../../notes/domain/sticky_note.dart';

/// Home aggregate from `home.get` (docs/api-contract.md, coding-standard.md).
class HomeSnapshot {
  const HomeSnapshot({
    required this.greeting,
    required this.anniversaryDate,
    required this.daysTogether,
    required this.todayStickyNotes,
    required this.stickyNotesCount,
    required this.fetchedAt,
    this.fromCache = false,
  });

  final String greeting;
  final DateTime anniversaryDate;
  final int daysTogether;
  final List<StickyNote> todayStickyNotes;
  final int stickyNotesCount;
  final DateTime fetchedAt;
  final bool fromCache;

  HomeSnapshot copyWith({
    String? greeting,
    DateTime? anniversaryDate,
    int? daysTogether,
    List<StickyNote>? todayStickyNotes,
    int? stickyNotesCount,
    DateTime? fetchedAt,
    bool? fromCache,
  }) {
    return HomeSnapshot(
      greeting: greeting ?? this.greeting,
      anniversaryDate: anniversaryDate ?? this.anniversaryDate,
      daysTogether: daysTogether ?? this.daysTogether,
      todayStickyNotes: todayStickyNotes ?? this.todayStickyNotes,
      stickyNotesCount: stickyNotesCount ?? this.stickyNotesCount,
      fetchedAt: fetchedAt ?? this.fetchedAt,
      fromCache: fromCache ?? this.fromCache,
    );
  }
}

/// UI-facing home state with refresh/soft-warning flags (state-management.md §7).
class HomeViewState {
  const HomeViewState({
    required this.snapshot,
    this.isRefreshing = false,
    this.softWarning = false,
  });

  final HomeSnapshot snapshot;
  final bool isRefreshing;
  final bool softWarning;

  HomeViewState copyWith({
    HomeSnapshot? snapshot,
    bool? isRefreshing,
    bool? softWarning,
  }) {
    return HomeViewState(
      snapshot: snapshot ?? this.snapshot,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      softWarning: softWarning ?? this.softWarning,
    );
  }
}
