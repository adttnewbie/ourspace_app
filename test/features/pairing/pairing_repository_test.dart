import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ourspace_app/core/error/app_failure.dart';
import 'package:ourspace_app/core/network/api_client.dart';
import 'package:ourspace_app/features/pairing/data/pairing_repository_impl.dart';
import 'package:ourspace_app/features/pairing/domain/pairing_result.dart';

class _FakeApiClient extends ApiClient {
  _FakeApiClient() : super(Dio());

  Object? result;
  String? lastAction;
  Map<String, dynamic>? lastPayload;
  String? lastMemberId;
  String? lastSessionToken;
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
    lastMemberId = memberId;
    lastSessionToken = sessionToken;
    final r = result;
    if (r is AppFailure) throw r;
    if (r is Map<String, dynamic>) return r;
    if (r is Exception) throw r;
    return <String, dynamic>{};
  }
}

void main() {
  group('PairingRepositoryImpl (step 2.2)', () {
    late _FakeApiClient api;
    late PairingRepositoryImpl repo;

    setUp(() {
      api = _FakeApiClient();
      repo = PairingRepositoryImpl(apiClient: api);
    });

    test('start_postsActionAndMapsWaiting', () async {
      api.result = <String, dynamic>{
        'pairingSessionId': 'pair_123',
        'status': 'waiting',
        'expiresAt': '2026-07-02T08:00:30.000Z',
      };

      final result = await repo.start(nickname: 'Ae');

      expect(api.lastAction, 'pairing.start');
      expect(api.lastPayload, <String, dynamic>{'nickname': 'Ae'});
      expect(api.lastMemberId, '');
      expect(api.lastSessionToken, '');
      expect(result, isA<PairingWaiting>());
      expect((result as PairingWaiting).pairingSessionId, 'pair_123');
    });

    test('signal_postsActionAndMapsWaiting', () async {
      api.result = <String, dynamic>{
        'status': 'waiting',
        'expiresAt': '2026-07-02T08:00:30.000Z',
      };

      final result = await repo.signal(
        pairingSessionId: 'pair_123',
        nickname: 'Ae',
      );

      expect(api.lastAction, 'pairing.signal');
      expect(api.lastPayload, <String, dynamic>{
        'pairingSessionId': 'pair_123',
        'nickname': 'Ae',
      });
      expect(result, isA<PairingWaiting>());
    });

    test('status_postsActionAndMapsPaired', () async {
      api.result = <String, dynamic>{
        'status': 'paired',
        'memberId': 'member_a',
        'sessionToken': 'session_test_token',
        'anniversaryDate': '2026-07-02T08:00:12.000Z',
        'members': [
          {'id': 'member_a', 'nickname': 'Ae'},
          {'id': 'member_b', 'nickname': 'Be'},
        ],
      };

      final result = await repo.status(pairingSessionId: 'pair_123');

      expect(api.lastAction, 'pairing.status');
      expect(result, isA<PairingPaired>());
      expect((result as PairingPaired).memberId, 'member_a');
    });

    test('start_apiFailure_rethrows', () async {
      api.result = const ApiFailure(code: 'PAIRING_EXPIRED');
      expect(
        () => repo.start(nickname: 'Ae'),
        throwsA(
          isA<ApiFailure>().having((e) => e.code, 'code', 'PAIRING_EXPIRED'),
        ),
      );
    });
  });
}
