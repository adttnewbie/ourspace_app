import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ourspace_app/core/error/app_failure.dart';
import 'package:ourspace_app/core/network/api_client.dart';
import 'package:ourspace_app/core/storage/cache_store.dart';
import 'package:ourspace_app/features/home/data/home_repository_impl.dart';

class _FakeApiClient extends ApiClient {
  _FakeApiClient() : super(Dio());

  Object? result;
  String? lastAction;
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
    final r = result;
    if (r is AppFailure) throw r;
    if (r is Map<String, dynamic>) return r;
    if (r is Exception) throw r;
    return <String, dynamic>{};
  }
}

Map<String, dynamic> _homePayload({int days = 1}) => <String, dynamic>{
  'greeting': 'Hai, Nama',
  'anniversaryDate': '2026-07-02T08:00:12.000Z',
  'daysTogether': days,
  'today': {'stickyNotes': <dynamic>[]},
  'counts': {'stickyNotes': 0},
};

void main() {
  group('HomeRepositoryImpl (step 2.3)', () {
    late InMemoryCacheStore cache;
    late _FakeApiClient api;
    late bool online;
    late HomeRepositoryImpl repo;

    setUp(() {
      cache = InMemoryCacheStore();
      api = _FakeApiClient();
      online = true;
      repo = HomeRepositoryImpl(
        apiClient: api,
        cacheStore: cache,
        isOnline: () => online,
      );
    });

    test('get_network_writesCache', () async {
      api.result = _homePayload();
      final snap = await repo.get();
      expect(api.lastAction, 'home.get');
      expect(snap.greeting, 'Hai, Nama');
      expect(snap.fromCache, isFalse);
      expect(await cache.read('home.get'), isNotNull);
    });

    test('get_withinTtl_skipsNetwork', () async {
      api.result = _homePayload();
      await repo.get();
      api.calls = 0;
      final snap = await repo.get();
      expect(api.calls, 0);
      expect(snap.fromCache, isTrue);
    });

    test('fetchFresh_alwaysHitsNetwork', () async {
      api.result = _homePayload();
      await repo.get();
      api.calls = 0;
      api.result = _homePayload(days: 9);
      final snap = await repo.fetchFresh();
      expect(api.calls, 1);
      expect(snap.daysTogether, 9);
      expect(snap.fromCache, isFalse);
    });

    test('get_offline_noCache_throwsNetworkOffline', () async {
      online = false;
      expect(
        () => repo.get(),
        throwsA(
          isA<NetworkFailure>().having(
            (e) => e.code,
            'code',
            'NETWORK_OFFLINE',
          ),
        ),
      );
    });

    test('get_offline_withCache_returnsStale', () async {
      api.result = _homePayload(days: 4);
      await repo.get();
      online = false;
      api.calls = 0;
      final snap = await repo.get(force: true);
      expect(api.calls, 0);
      expect(snap.daysTogether, 4);
      expect(snap.fromCache, isTrue);
    });

    test('get_networkFail_withCache_returnsCache', () async {
      api.result = _homePayload(days: 2);
      await repo.get();
      api.result = const NetworkFailure(code: 'NETWORK_TIMEOUT');
      final snap = await repo.get(force: true);
      expect(snap.daysTogether, 2);
      expect(snap.fromCache, isTrue);
    });

    test('clearCache_removesEntry', () async {
      api.result = _homePayload();
      await repo.get();
      await repo.clearCache();
      expect(await repo.readCache(), isNull);
    });
  });
}
