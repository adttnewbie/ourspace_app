import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ourspace_app/core/connectivity/connectivity_providers.dart';
import 'package:ourspace_app/core/error/app_failure.dart';
import 'package:ourspace_app/features/home/domain/home_repository.dart';
import 'package:ourspace_app/features/home/domain/home_snapshot.dart';
import 'package:ourspace_app/features/home/presentation/home_providers.dart';
import 'package:ourspace_app/features/notes/domain/notes_repository.dart';
import 'package:ourspace_app/features/notes/domain/sticky_note.dart';
import 'package:ourspace_app/features/notes/presentation/notes_providers.dart';

StickyNote _note({
  String id = 'note_1',
  bool canEdit = true,
  String body = 'Hello',
}) {
  final t = DateTime.utc(2026, 7, 2, 8, 5);
  return StickyNote(
    id: id,
    body: body,
    color: 'pink',
    createdBy: 'member_a',
    createdByNickname: 'Ae',
    createdAt: t,
    updatedAt: t,
    canEdit: canEdit,
  );
}

class _FakeHomeRepo implements HomeRepository {
  int getCalls = 0;

  @override
  Future<HomeSnapshot> get({bool force = false}) async {
    getCalls++;
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
  Future<HomeSnapshot> fetchFresh() => get(force: true);

  @override
  Future<HomeSnapshot?> readCache() async => null;

  @override
  Future<void> clearCache() async {}
}

class _FakeNotesRepo implements NotesRepository {
  List<StickyNote> items = [_note()];
  int listCalls = 0;
  int createCalls = 0;
  int updateCalls = 0;
  int deleteCalls = 0;
  Object? createError;
  Object? deleteError;

  @override
  Future<NotesListResult> list({
    int limit = 50,
    String? cursor,
    bool force = false,
  }) async {
    listCalls++;
    return NotesListResult(
      items: List.of(items),
      fetchedAt: DateTime.now(),
    );
  }

  @override
  Future<NotesListResult> fetchFresh({int limit = 50, String? cursor}) async {
    listCalls++;
    return NotesListResult(
      items: List.of(items),
      fetchedAt: DateTime.now(),
    );
  }

  @override
  Future<NotesListResult?> readCache() async => null;

  @override
  Future<StickyNote?> create({
    required String body,
    required String color,
  }) async {
    createCalls++;
    if (createError != null) throw createError!;
    final n = _note(id: 'note_new', body: body).copyWith(color: color);
    items = [n, ...items];
    return n;
  }

  @override
  Future<StickyNote?> update({
    required String id,
    required String body,
    required String color,
  }) async {
    updateCalls++;
    final n = items.firstWhere((e) => e.id == id).copyWith(
          body: body,
          color: color,
          updatedAt: DateTime.now(),
        );
    items = items.map((e) => e.id == id ? n : e).toList();
    return n;
  }

  @override
  Future<void> delete({required String id}) async {
    deleteCalls++;
    if (deleteError != null) throw deleteError!;
    items = items.where((e) => e.id != id).toList();
  }

  @override
  Future<void> clearCache() async {}
}

void main() {
  group('NotesListNotifier (step 2.4)', () {
    late _FakeNotesRepo notesRepo;
    late _FakeHomeRepo homeRepo;
    late ProviderContainer container;

    setUp(() {
      notesRepo = _FakeNotesRepo();
      homeRepo = _FakeHomeRepo();
      container = ProviderContainer(
        overrides: [
          notesRepositoryProvider.overrideWithValue(notesRepo),
          homeRepositoryProvider.overrideWithValue(homeRepo),
          isOnlineProvider.overrideWithValue(true),
        ],
      );
    });

    tearDown(() => container.dispose());

    test('build_loadsList', () async {
      final state = await container.read(notesListProvider.future);
      expect(state.items.single.id, 'note_1');
      expect(notesRepo.listCalls, greaterThanOrEqualTo(1));
    });

    test('create_patchesList_andInvalidatesHome', () async {
      await container.read(notesListProvider.future);
      final homeBefore = homeRepo.getCalls;

      await container
          .read(notesListProvider.notifier)
          .create(body: 'New', color: 'mint');

      final state = container.read(notesListProvider).asData!.value;
      expect(state.items.first.id, 'note_new');
      expect(notesRepo.createCalls, 1);
      await container.read(homeProvider.future);
      expect(homeRepo.getCalls, greaterThan(homeBefore));
    });

    test('updateNote_patchesBody', () async {
      await container.read(notesListProvider.future);
      await container.read(notesListProvider.notifier).updateNote(
            id: 'note_1',
            body: 'Edited',
            color: 'yellow',
          );
      final state = container.read(notesListProvider).asData!.value;
      expect(state.items.single.body, 'Edited');
      expect(notesRepo.updateCalls, 1);
    });

    test('remove_softDeletesFromList', () async {
      await container.read(notesListProvider.future);
      await container.read(notesListProvider.notifier).remove(id: 'note_1');
      final state = container.read(notesListProvider).asData!.value;
      expect(state.items, isEmpty);
      expect(notesRepo.deleteCalls, 1);
    });

    test('create_offline_throwsOfflineMutationBlocked', () async {
      container.dispose();
      container = ProviderContainer(
        overrides: [
          notesRepositoryProvider.overrideWithValue(notesRepo),
          homeRepositoryProvider.overrideWithValue(homeRepo),
          isOnlineProvider.overrideWithValue(false),
        ],
      );
      await container.read(notesListProvider.future);
      expect(
        () => container
            .read(notesListProvider.notifier)
            .create(body: 'x', color: 'pink'),
        throwsA(
          isA<ValidationFailure>().having(
            (e) => e.code,
            'code',
            'OFFLINE_MUTATION_BLOCKED',
          ),
        ),
      );
    });
  });
}
