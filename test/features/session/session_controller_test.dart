import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ourspace_app/core/error/app_failure.dart';
import 'package:ourspace_app/core/router/session_auth.dart';
import 'package:ourspace_app/core/storage/secure_storage.dart';
import 'package:ourspace_app/core/storage/storage_keys.dart';
import 'package:ourspace_app/core/storage/storage_providers.dart';
import 'package:ourspace_app/features/session/domain/member.dart';
import 'package:ourspace_app/features/session/domain/session_repository.dart';
import 'package:ourspace_app/features/session/domain/session_snapshot.dart';
import 'package:ourspace_app/features/session/presentation/session_controller.dart';
import 'package:ourspace_app/features/session/presentation/session_providers.dart';

class _FakeSessionRepository implements SessionRepository {
  _FakeSessionRepository({
    this.hasCredentials = false,
    this.snapshot,
    this.error,
  });

  bool hasCredentials;
  SessionSnapshot? snapshot;
  Object? error;
  int resumeCalls = 0;
  int clearCalls = 0;

  @override
  Future<bool> hasLocalCredentials() async => hasCredentials;

  @override
  Future<SessionSnapshot?> resume({bool force = false}) async {
    resumeCalls++;
    final err = error;
    if (err != null) {
      if (err is Exception) throw err;
      throw Exception(err);
    }
    return snapshot;
  }

  @override
  Future<void> clearLocal() async {
    clearCalls++;
    hasCredentials = false;
  }
}

SessionSnapshot _okSnapshot() => SessionSnapshot(
  member: const Member(id: 'member_a', nickname: 'A'),
  members: const [
    Member(id: 'member_a', nickname: 'A'),
    Member(id: 'member_b', nickname: 'B'),
  ],
  anniversaryDate: DateTime.parse('2026-07-02T08:00:12.000Z'),
  fetchedAt: DateTime.now(),
);

void main() {
  group('SessionController (step 2.1 DoD)', () {
    test('validTokens_resumeOk_authenticated', () async {
      final storage = FakeSecureStorage();
      await storage.write(StorageKeys.memberId, 'member_a');
      await storage.write(StorageKeys.sessionToken, 'tok');

      final repo = _FakeSessionRepository(
        hasCredentials: true,
        snapshot: _okSnapshot(),
      );
      final container = ProviderContainer(
        overrides: [
          secureStorageProvider.overrideWithValue(storage),
          sessionRepositoryProvider.overrideWithValue(repo),
        ],
      );
      addTearDown(container.dispose);

      final auth = container.read(sessionAuthNotifierProvider);
      // Drain auto-bootstrap from build().
      await container.read(sessionControllerProvider.notifier).resume();

      expect(
        container.read(sessionControllerProvider).status,
        SessionPhase.authenticated,
      );
      expect(auth.status, SessionAuthStatus.authenticated);
      expect(container.read(currentMemberIdProvider), 'member_a');
      expect(repo.clearCalls, 0);
    });

    test('unauthorized_clearsLocal_unauthenticated', () async {
      final storage = FakeSecureStorage();
      await storage.write(StorageKeys.memberId, 'member_a');
      await storage.write(StorageKeys.sessionToken, 'bad');

      final repo = _FakeSessionRepository(
        hasCredentials: true,
        error: const ApiFailure(code: 'UNAUTHORIZED', message: 'bad'),
      );
      final container = ProviderContainer(
        overrides: [
          secureStorageProvider.overrideWithValue(storage),
          sessionRepositoryProvider.overrideWithValue(repo),
        ],
      );
      addTearDown(container.dispose);

      final auth = container.read(sessionAuthNotifierProvider);
      await container.read(sessionControllerProvider.notifier).resume();

      expect(
        container.read(sessionControllerProvider).status,
        SessionPhase.unauthenticated,
      );
      expect(auth.status, SessionAuthStatus.unauthenticated);
      expect(repo.clearCalls, 1);
    });

    test('network_keepsTokens_temporaryError', () async {
      final storage = FakeSecureStorage();
      await storage.write(StorageKeys.memberId, 'member_a');
      await storage.write(StorageKeys.sessionToken, 'tok');

      final repo = _FakeSessionRepository(
        hasCredentials: true,
        error: NetworkFailure.timeout,
      );
      final container = ProviderContainer(
        overrides: [
          secureStorageProvider.overrideWithValue(storage),
          sessionRepositoryProvider.overrideWithValue(repo),
        ],
      );
      addTearDown(container.dispose);

      final auth = container.read(sessionAuthNotifierProvider);
      await container.read(sessionControllerProvider.notifier).resume();

      expect(
        container.read(sessionControllerProvider).status,
        SessionPhase.temporaryError,
      );
      expect(auth.status, SessionAuthStatus.temporaryError);
      expect(repo.clearCalls, 0);
      expect(repo.hasCredentials, isTrue);
      expect(await storage.read(StorageKeys.sessionToken), 'tok');
    });

    test('noTokens_unauthenticated', () async {
      final storage = FakeSecureStorage();
      final repo = _FakeSessionRepository(hasCredentials: false);
      final container = ProviderContainer(
        overrides: [
          secureStorageProvider.overrideWithValue(storage),
          sessionRepositoryProvider.overrideWithValue(repo),
        ],
      );
      addTearDown(container.dispose);

      await container.read(sessionControllerProvider.notifier).resume();

      expect(
        container.read(sessionControllerProvider).status,
        SessionPhase.unauthenticated,
      );
      expect(repo.resumeCalls, 0);
    });
  });
}
