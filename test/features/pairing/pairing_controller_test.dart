import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ourspace_app/core/connectivity/connectivity_providers.dart';
import 'package:ourspace_app/core/error/app_failure.dart';
import 'package:ourspace_app/core/router/session_auth.dart';
import 'package:ourspace_app/core/storage/secure_storage.dart';
import 'package:ourspace_app/core/storage/storage_keys.dart';
import 'package:ourspace_app/core/storage/storage_providers.dart';
import 'package:ourspace_app/features/pairing/domain/pairing_repository.dart';
import 'package:ourspace_app/features/pairing/domain/pairing_result.dart';
import 'package:ourspace_app/features/pairing/presentation/pairing_controller.dart';
import 'package:ourspace_app/features/pairing/presentation/pairing_providers.dart';
import 'package:ourspace_app/features/pairing/presentation/pairing_state.dart';
import 'package:ourspace_app/features/session/domain/member.dart';
import 'package:ourspace_app/features/session/presentation/session_controller.dart';

class _FakePairingRepository implements PairingRepository {
  PairingResult? startResult;
  PairingResult? signalResult;
  PairingResult? statusResult;
  Object? startError;
  Object? signalError;
  Object? statusError;
  int startCalls = 0;
  int signalCalls = 0;
  int statusCalls = 0;
  String? lastNickname;
  String? lastSessionId;

  @override
  Future<PairingResult> start({required String nickname}) async {
    startCalls++;
    lastNickname = nickname;
    final err = startError;
    if (err != null) {
      if (err is Exception) throw err;
      throw Exception(err);
    }
    return startResult ??
        PairingWaiting(
          pairingSessionId: 'pair_1',
          expiresAt: DateTime.now().add(const Duration(seconds: 30)),
        );
  }

  @override
  Future<PairingResult> signal({
    required String pairingSessionId,
    required String nickname,
  }) async {
    signalCalls++;
    lastSessionId = pairingSessionId;
    lastNickname = nickname;
    final err = signalError;
    if (err != null) {
      if (err is Exception) throw err;
      throw Exception(err);
    }
    return signalResult ??
        PairingWaiting(
          pairingSessionId: pairingSessionId,
          expiresAt: DateTime.now().add(const Duration(seconds: 25)),
        );
  }

  @override
  Future<PairingResult> status({required String pairingSessionId}) async {
    statusCalls++;
    lastSessionId = pairingSessionId;
    final err = statusError;
    if (err != null) {
      if (err is Exception) throw err;
      throw Exception(err);
    }
    return statusResult ??
        PairingWaiting(
          pairingSessionId: pairingSessionId,
          expiresAt: DateTime.now().add(const Duration(seconds: 20)),
        );
  }
}

void main() {
  group('PairingController (step 2.2)', () {
    late FakeSecureStorage storage;
    late _FakePairingRepository pairingRepo;
    late ProviderContainer container;

    setUp(() {
      storage = FakeSecureStorage();
      pairingRepo = _FakePairingRepository();
      container = ProviderContainer(
        overrides: [
          secureStorageProvider.overrideWithValue(storage),
          pairingRepositoryProvider.overrideWithValue(pairingRepo),
          isOnlineProvider.overrideWithValue(true),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('idle_holdingCancel_returnsIdle', () {
      final ctrl = container.read(pairingControllerProvider.notifier);
      ctrl.setNickname('Ae');
      ctrl.beginHold();
      expect(
        container.read(pairingControllerProvider).phase,
        PairingPhase.holding,
      );
      ctrl.cancelHold();
      expect(
        container.read(pairingControllerProvider).phase,
        PairingPhase.idle,
      );
      expect(pairingRepo.startCalls, 0);
      expect(pairingRepo.signalCalls, 0);
    });

    test('completeHold_waiting_startsPoll', () async {
      final ctrl = container.read(pairingControllerProvider.notifier);
      ctrl.setNickname('Ae');
      ctrl.beginHold();
      await ctrl.completeHold();

      final state = container.read(pairingControllerProvider);
      expect(state.phase, PairingPhase.waiting);
      expect(state.pairingSessionId, 'pair_1');
      expect(pairingRepo.startCalls, 1);
      expect(pairingRepo.signalCalls, 1);

      await Future<void>.delayed(const Duration(milliseconds: 50));
      container.dispose();
    });

    test('completeHold_paired_writesSecureAndAuthenticates', () async {
      pairingRepo.signalResult = PairingPaired(
        memberId: 'member_a',
        sessionToken: 'session_test_token',
        anniversaryDate: DateTime.parse('2026-07-02T08:00:12.000Z'),
        members: const [
          Member(id: 'member_a', nickname: 'Ae'),
          Member(id: 'member_b', nickname: 'Be'),
        ],
      );

      final ctrl = container.read(pairingControllerProvider.notifier);
      ctrl.setNickname('Ae');
      ctrl.beginHold();
      await ctrl.completeHold();

      expect(
        container.read(pairingControllerProvider).phase,
        PairingPhase.paired,
      );
      expect(await storage.read(StorageKeys.memberId), 'member_a');
      expect(await storage.read(StorageKeys.sessionToken), 'session_test_token');
      expect(
        container.read(sessionControllerProvider).status,
        SessionPhase.authenticated,
      );
      expect(
        container.read(sessionAuthNotifierProvider).status,
        SessionAuthStatus.authenticated,
      );
    });

    test('signal_PAIRING_EXPIRED_entersExpired', () async {
      pairingRepo.signalError = const ApiFailure(code: 'PAIRING_EXPIRED');

      final ctrl = container.read(pairingControllerProvider.notifier);
      ctrl.setNickname('Ae');
      ctrl.beginHold();
      await ctrl.completeHold();

      expect(
        container.read(pairingControllerProvider).phase,
        PairingPhase.expired,
      );
    });

    test('retry_resetsToIdle_clearsSessionId', () async {
      final ctrl = container.read(pairingControllerProvider.notifier);
      ctrl.setNickname('Ae');
      ctrl.beginHold();
      await ctrl.completeHold();
      expect(
        container.read(pairingControllerProvider).phase,
        PairingPhase.waiting,
      );

      ctrl.retry();
      final state = container.read(pairingControllerProvider);
      expect(state.phase, PairingPhase.idle);
      expect(state.pairingSessionId, isNull);
      expect(state.nickname, 'Ae');
    });

    test('dispose_cancelsPollTimer', () async {
      final ctrl = container.read(pairingControllerProvider.notifier);
      ctrl.setNickname('Ae');
      ctrl.beginHold();
      await ctrl.completeHold();
      expect(
        container.read(pairingControllerProvider).phase,
        PairingPhase.waiting,
      );

      final callsBefore = pairingRepo.statusCalls;
      container.dispose();
      await Future<void>.delayed(const Duration(seconds: 3));
      expect(pairingRepo.statusCalls, callsBefore);
    });

    test('offline_beginHold_error', () {
      final offline = ProviderContainer(
        overrides: [
          secureStorageProvider.overrideWithValue(storage),
          pairingRepositoryProvider.overrideWithValue(pairingRepo),
          isOnlineProvider.overrideWithValue(false),
        ],
      );
      addTearDown(offline.dispose);

      final ctrl = offline.read(pairingControllerProvider.notifier);
      ctrl.setNickname('Ae');
      ctrl.beginHold();
      final state = offline.read(pairingControllerProvider);
      expect(state.phase, PairingPhase.error);
      expect(state.failure?.code, 'OFFLINE_MUTATION_BLOCKED');
    });
  });
}
