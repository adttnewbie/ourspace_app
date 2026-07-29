import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ourspace_app/core/error/app_failure.dart';
import 'package:ourspace_app/core/network/api_client.dart';
import 'package:ourspace_app/core/storage/secure_storage.dart';
import 'package:ourspace_app/core/storage/storage_keys.dart';
import 'package:ourspace_app/features/session/data/session_repository_impl.dart';

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

void main() {
  group('SessionRepositoryImpl (step 2.1)', () {
    late FakeSecureStorage storage;
    late _FakeApiClient api;
    late SessionRepositoryImpl repo;

    setUp(() {
      storage = FakeSecureStorage();
      api = _FakeApiClient();
      repo = SessionRepositoryImpl(apiClient: api, secureStorage: storage);
    });

    test('resume_noCredentials_returnsNull', () async {
      final snap = await repo.resume();
      expect(snap, isNull);
      expect(api.calls, 0);
    });

    test('resume_success_mapsDto', () async {
      await storage.write(StorageKeys.memberId, 'member_a');
      await storage.write(StorageKeys.sessionToken, 'tok');
      api.result = <String, dynamic>{
        'member': {'id': 'member_a', 'nickname': 'Nama Kamu'},
        'members': [
          {'id': 'member_a', 'nickname': 'Nama Kamu'},
          {'id': 'member_b', 'nickname': 'Nama Pasangan'},
        ],
        'anniversaryDate': '2026-07-02T08:00:12.000Z',
      };

      final snap = await repo.resume();
      expect(api.lastAction, 'session.resume');
      expect(snap, isNotNull);
      expect(snap!.member.id, 'member_a');
      expect(snap.member.nickname, 'Nama Kamu');
      expect(snap.members.length, 2);
      expect(
        snap.anniversaryDate.toUtc().toIso8601String(),
        '2026-07-02T08:00:12.000Z',
      );
    });

    test('resume_unauthorized_rethrows', () async {
      await storage.write(StorageKeys.memberId, 'member_a');
      await storage.write(StorageKeys.sessionToken, 'bad');
      api.result = const ApiFailure(code: 'UNAUTHORIZED', message: 'nope');

      expect(
        () => repo.resume(),
        throwsA(
          isA<ApiFailure>().having((e) => e.code, 'code', 'UNAUTHORIZED'),
        ),
      );
    });

    test('clearLocal_deletesBothKeys', () async {
      await storage.write(StorageKeys.memberId, 'm');
      await storage.write(StorageKeys.sessionToken, 't');
      await repo.clearLocal();
      expect(await storage.read(StorageKeys.memberId), isNull);
      expect(await storage.read(StorageKeys.sessionToken), isNull);
    });
  });
}
