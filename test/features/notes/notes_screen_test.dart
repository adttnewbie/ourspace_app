import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ourspace_app/core/connectivity/connectivity_providers.dart';
import 'package:ourspace_app/core/theme/app_theme.dart';
import 'package:ourspace_app/features/home/domain/home_repository.dart';
import 'package:ourspace_app/features/home/domain/home_snapshot.dart';
import 'package:ourspace_app/features/home/presentation/home_providers.dart';
import 'package:ourspace_app/features/notes/domain/notes_repository.dart';
import 'package:ourspace_app/features/notes/domain/sticky_note.dart';
import 'package:ourspace_app/features/notes/presentation/notes_providers.dart';
import 'package:ourspace_app/features/notes/presentation/notes_screen.dart';

StickyNote _note({String id = 'note_1', bool canEdit = true}) {
  final t = DateTime.utc(2026, 7, 2, 8, 5);
  return StickyNote(
    id: id,
    body: 'Hello note',
    color: 'mint',
    createdBy: 'member_a',
    createdByNickname: 'Ae',
    createdAt: t,
    updatedAt: t,
    canEdit: canEdit,
  );
}

class _FakeHomeRepo implements HomeRepository {
  @override
  Future<void> clearCache() async {}

  @override
  Future<HomeSnapshot> fetchFresh() async {
    return HomeSnapshot(
      greeting: 'Hai',
      anniversaryDate: DateTime.utc(2026, 7, 2),
      daysTogether: 1,
      todayStickyNotes: const [],
      stickyNotesCount: 0,
      fetchedAt: DateTime.now(),
    );
  }

  @override
  Future<HomeSnapshot> get({bool force = false}) => fetchFresh();

  @override
  Future<HomeSnapshot?> readCache() async => null;
}

class _FakeNotesRepo implements NotesRepository {
  _FakeNotesRepo(this.items);

  List<StickyNote> items;

  @override
  Future<void> clearCache() async {}

  @override
  Future<StickyNote?> create({
    required String body,
    required String color,
  }) async {
    final n = _note(id: 'new', canEdit: true).copyWith(body: body, color: color);
    items = [n, ...items];
    return n;
  }

  @override
  Future<void> delete({required String id}) async {
    items = items.where((e) => e.id != id).toList();
  }

  @override
  Future<NotesListResult> fetchFresh({int limit = 50, String? cursor}) async {
    return NotesListResult(items: List.of(items), fetchedAt: DateTime.now());
  }

  @override
  Future<NotesListResult> list({
    int limit = 50,
    String? cursor,
    bool force = false,
  }) async {
    return NotesListResult(items: List.of(items), fetchedAt: DateTime.now());
  }

  @override
  Future<NotesListResult?> readCache() async => null;

  @override
  Future<StickyNote?> update({
    required String id,
    required String body,
    required String color,
  }) async {
    final idx = items.indexWhere((e) => e.id == id);
    if (idx < 0) return null;
    final u = items[idx].copyWith(body: body, color: color);
    items = [...items]..[idx] = u;
    return u;
  }
}

void main() {
  group('NotesScreen (step 2.4)', () {
    testWidgets('shows_list_and_header', (tester) async {
      final notesRepo = _FakeNotesRepo([_note()]);
      final container = ProviderContainer(
        overrides: [
          notesRepositoryProvider.overrideWithValue(notesRepo),
          homeRepositoryProvider.overrideWithValue(_FakeHomeRepo()),
          isOnlineProvider.overrideWithValue(true),
        ],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            theme: AppTheme.light(),
            home: const Scaffold(body: NotesScreen()),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Notes'), findsOneWidget);
      expect(find.text('Sticky'), findsOneWidget);
      expect(find.text('Hello note'), findsOneWidget);
      expect(find.byIcon(Icons.edit_outlined), findsOneWidget);
    });

    testWidgets('empty_shows_cta', (tester) async {
      final notesRepo = _FakeNotesRepo([]);
      final container = ProviderContainer(
        overrides: [
          notesRepositoryProvider.overrideWithValue(notesRepo),
          homeRepositoryProvider.overrideWithValue(_FakeHomeRepo()),
          isOnlineProvider.overrideWithValue(true),
        ],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            theme: AppTheme.light(),
            home: const Scaffold(body: NotesScreen()),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Belum ada note'), findsOneWidget);
      expect(find.text('Tambah note'), findsOneWidget);
    });
  });
}
