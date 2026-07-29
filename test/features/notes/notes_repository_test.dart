import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ourspace_app/core/error/app_failure.dart';
import 'package:ourspace_app/core/network/api_client.dart';
import 'package:ourspace_app/core/storage/cache_store.dart';
import 'package:ourspace_app/features/notes/data/notes_repository_impl.dart';
import 'package:ourspace_app/features/notes/data/sticky_note_dto.dart';

class _FakeApiClient extends ApiClient {
  _FakeApiClient() : super(Dio());

  Object? result;
  String? lastAction;
  Map<String, dynamic>? lastPayload;
  int calls = 0;

  @override
  Future<Map<String, dynamic>> postAction({
    required String action,
    Map<String, dynamic>? payload,
    String? memberId,
    String? sessionToken,
    CancelToken? cancelToken,
  }) async {
    calls++;
    lastAction = action;
    lastPayload = payload;
    final r = result;
    if (r is AppFailure) throw r;
    if (r is Map<String, dynamic>) return r;
    if (r is Exception) throw r;
    return <String, dynamic>{};
  }
}

Map<String, dynamic> _noteMap({
  String id = 'note_1',
  bool canEdit = true,
}) =>
    <String, dynamic>{
      'id': id,
      'body': 'Hello',
      'color': 'pink',
      'createdBy': 'member_a',
      'createdByNickname': 'Ae',
      'createdAt': '2026-07-02T08:05:00.000Z',
      'updatedAt': '2026-07-02T08:05:00.000Z',
      'canEdit': canEdit,
    };

void main() {
  group('NotesRepositoryImpl (step 2.4)', () {
    late InMemoryCacheStore cache;
    late _FakeApiClient api;
    late NotesRepositoryImpl repo;
    var online = true;

    setUp(() {
      cache = InMemoryCacheStore();
      api = _FakeApiClient();
      online = true;
      repo = NotesRepositoryImpl(
        apiClient: api,
        cacheStore: cache,
        isOnline: () => online,
      );
    });

    test('list_network_writesCache', () async {
      api.result = <String, dynamic>{
        'items': [_noteMap()],
        'nextCursor': null,
      };
      final result = await repo.list();
      expect(api.lastAction, 'notes.list');
      expect(result.items.single.id, 'note_1');
      expect(await cache.read(StickyNoteDto.cacheKey), isNotNull);
    });

    test('list_withinTtl_skipsNetwork', () async {
      api.result = <String, dynamic>{
        'items': [_noteMap()],
        'nextCursor': null,
      };
      await repo.list();
      api.calls = 0;
      final second = await repo.list();
      expect(api.calls, 0);
      expect(second.fromCache, isTrue);
    });

    test('fetchFresh_alwaysHitsNetwork', () async {
      api.result = <String, dynamic>{
        'items': [_noteMap()],
        'nextCursor': null,
      };
      await repo.list();
      api.calls = 0;
      await repo.fetchFresh();
      expect(api.calls, 1);
    });

    test('list_offline_noCache_throwsNetworkOffline', () async {
      online = false;
      expect(
        () => repo.list(),
        throwsA(
          isA<NetworkFailure>().having(
            (e) => e.code,
            'code',
            'NETWORK_OFFLINE',
          ),
        ),
      );
    });

    test('list_offline_withCache_returnsStale', () async {
      api.result = <String, dynamic>{
        'items': [_noteMap()],
        'nextCursor': null,
      };
      await repo.list();
      online = false;
      api.calls = 0;
      final stale = await repo.list();
      expect(api.calls, 0);
      expect(stale.items.single.id, 'note_1');
    });

    test('create_postsNotesCreate', () async {
      api.result = _noteMap(id: 'note_new');
      final note = await repo.create(body: 'Hi', color: 'mint');
      expect(api.lastAction, 'notes.create');
      expect(api.lastPayload?['body'], 'Hi');
      expect(api.lastPayload?['color'], 'mint');
      expect(note?.id, 'note_new');
    });

    test('update_postsNotesUpdate', () async {
      api.result = _noteMap(id: 'note_1');
      await repo.update(id: 'note_1', body: 'Edited', color: 'yellow');
      expect(api.lastAction, 'notes.update');
      expect(api.lastPayload?['id'], 'note_1');
      expect(api.lastPayload?['body'], 'Edited');
    });

    test('delete_postsNotesDelete_softDelete', () async {
      api.result = <String, dynamic>{};
      await repo.delete(id: 'note_1');
      expect(api.lastAction, 'notes.delete');
      expect(api.lastPayload?['id'], 'note_1');
    });

    test('delete_forbidden_rethrows', () async {
      api.result = const ApiFailure(code: 'FORBIDDEN', message: 'nope');
      expect(
        () => repo.delete(id: 'note_1'),
        throwsA(isA<ApiFailure>().having((e) => e.code, 'code', 'FORBIDDEN')),
      );
    });

    test('clearCache_removesEntry', () async {
      api.result = <String, dynamic>{
        'items': [_noteMap()],
        'nextCursor': null,
      };
      await repo.list();
      await repo.clearCache();
      expect(await cache.read(StickyNoteDto.cacheKey), isNull);
    });
  });
}
