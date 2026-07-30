import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ourspace_app/core/connectivity/connectivity_providers.dart';
import 'package:ourspace_app/core/error/app_failure.dart';
import 'package:ourspace_app/core/router/session_auth.dart';
import 'package:ourspace_app/features/home/domain/home_repository.dart';
import 'package:ourspace_app/features/home/domain/home_snapshot.dart';
import 'package:ourspace_app/features/home/presentation/home_providers.dart';
import 'package:ourspace_app/features/notes/domain/notes_repository.dart';
import 'package:ourspace_app/features/notes/domain/sticky_note.dart';
import 'package:ourspace_app/features/notes/presentation/notes_providers.dart';
import 'package:ourspace_app/features/session/domain/member.dart';
import 'package:ourspace_app/features/session/domain/session_repository.dart';
import 'package:ourspace_app/features/session/domain/session_snapshot.dart';
import 'package:ourspace_app/features/session/presentation/session_controller.dart';
import 'package:ourspace_app/features/session/presentation/session_providers.dart';
import 'package:ourspace_app/features/settings/domain/settings_repository.dart';
import 'package:ourspace_app/features/settings/presentation/settings_providers.dart';

class _FakeSettingsRepo implements SettingsRepository {
  int healthCalls = 0;
  Object? healthError;

  @override
  Future<void> checkHealth() async {
    healthCalls++;
    if (healthError != null) throw healthError!;
  }
}

class _FakeSessionRepo implements SessionRepository {
  bool hasCreds = true;
  int resumeCalls = 0;
  int clearCalls = 0;
  bool forceResumeUnauthorized = false;

  @override
  Future<void> clearLocal() async {
    clearCalls++;
    hasCreds = false;
  }

  @override
  Future<bool> hasLocalCredentials() async => hasCreds;

  @override
  Future<SessionSnapshot?> resume({bool force = false}) async {
    resumeCalls++;
    if (!hasCreds) return null;
    if (forceResumeUnauthorized) {
      throw const ApiFailure(code: 'UNAUTHORIZED');
    }
    return SessionSnapshot(
      member: const Member(id: 'member_a', nickname: 'Ae'),
      members: const [
        Member(id: 'member_a', nickname: 'Ae'),
        Member(id: 'member_b', nickname: 'Be'),
      ],
      anniversaryDate: DateTime.utc(2026, 7, 2),
      fetchedAt: DateTime.now(),
    );
  }

  @override
  Future<void> writeLocal({
    required String memberId,
    required String sessionToken,
  }) async {
    hasCreds = true;
  }
}

class _FakeHomeRepo implements HomeRepository {
  int clearCalls = 0;

  @override
  Future<void> clearCache() async {
    clearCalls++;
  }

  @override
  Future<HomeSnapshot> fetchFresh() async => get();

  @override
  Future<HomeSnapshot> get({bool force = false}) async {
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
  Future<HomeSnapshot?> readCache() async => null;
}

class _FakeNotesRepo implements NotesRepository {
  int clearCalls = 0;

  @override
  Future<void> clearCache() async {
    clearCalls++;
  }

  @override
  Future<StickyNote?> create({
    required String body,
    required String color,
  }) async =>
      null;

  @override
  Future<void> delete({required String id}) async {}

  @override
  Future<NotesListResult> fetchFresh({int limit = 50, String? cursor}) async {
    return NotesListResult(items: const [], fetchedAt: DateTime.now());
  }

  @override
  Future<NotesListResult> list({
    int limit = 50,
    String? cursor,
    bool force = false,
  }) async {
    return NotesListResult(items: const [], fetchedAt: DateTime.now());
  }

  @override
  Future<NotesListResult?> readCache() async => null;

  @override
  Future<StickyNote?> update({
    required String id,
    required String body,
    required String color,
  }) async =>
      null;
}

void main() {
  group('SettingsDiagnosticsNotifier (step 2.5)', () {
    late ProviderContainer container;
    late _FakeSettingsRepo settingsRepo;
    late _FakeSessionRepo sessionRepo;
    late _FakeHomeRepo homeRepo;
    late _FakeNotesRepo notesRepo;
    late SessionAuthNotifier auth;

    setUp(() {
      settingsRepo = _FakeSettingsRepo();
      sessionRepo = _FakeSessionRepo();
      homeRepo = _FakeHomeRepo();
      notesRepo = _FakeNotesRepo();
      auth = SessionAuthNotifier()
        ..setStatus(SessionAuthStatus.authenticated);

      container = ProviderContainer(
        overrides: [
          settingsRepositoryProvider.overrideWithValue(settingsRepo),
          sessionRepositoryProvider.overrideWithValue(sessionRepo),
          homeRepositoryProvider.overrideWithValue(homeRepo),
          notesRepositoryProvider.overrideWithValue(notesRepo),
          sessionAuthNotifierProvider.overrideWith((ref) => auth),
          isOnlineProvider.overrideWithValue(true),
        ],
      );
    });

    tearDown(() => container.dispose());

    test('checkConnection_success_setsBackendOkMessage', () async {
      await container
          .read(settingsDiagnosticsProvider.notifier)
          .checkConnection();
      final s = container.read(settingsDiagnosticsProvider);
      expect(settingsRepo.healthCalls, 1);
      expect(s.lastOk, isTrue);
      expect(s.lastMessage, 'Backend tersambung.');
      expect(s.lastMessage!.toLowerCase(), isNot(contains('token')));
    });

    test('checkConnection_failure_setsErrorMessage', () async {
      settingsRepo.healthError = const NetworkFailure(code: 'NETWORK_TIMEOUT');
      try {
        await container
            .read(settingsDiagnosticsProvider.notifier)
            .checkConnection();
      } catch (_) {}
      final s = container.read(settingsDiagnosticsProvider);
      expect(s.lastOk, isFalse);
      expect(s.lastMessage, isNotNull);
      expect(s.lastMessage!.toLowerCase(), isNot(contains('sessiontoken')));
    });

    test('checkSession_forceResume_success', () async {
      await container.read(sessionControllerProvider.notifier).resume(force: true);
      await container.read(settingsDiagnosticsProvider.notifier).checkSession();
      final s = container.read(settingsDiagnosticsProvider);
      expect(sessionRepo.resumeCalls, greaterThanOrEqualTo(1));
      expect(s.lastOk, isTrue);
      expect(s.lastMessage, contains('Session valid'));
      expect(s.lastMessage!.toLowerCase(), isNot(contains('token')));
    });

    test('clearLocalSession_clearsCachesAndSession', () async {
      await container.read(sessionControllerProvider.notifier).resume(force: true);
      expect(
        container.read(sessionControllerProvider).status,
        SessionPhase.authenticated,
      );

      await container
          .read(settingsDiagnosticsProvider.notifier)
          .clearLocalSession();

      expect(sessionRepo.clearCalls, 1);
      expect(homeRepo.clearCalls, 1);
      expect(notesRepo.clearCalls, 1);
      expect(
        container.read(sessionControllerProvider).status,
        SessionPhase.unauthenticated,
      );
      expect(auth.status, SessionAuthStatus.unauthenticated);
    });

    test('checkConnection_offline_throws', () async {
      container.dispose();
      container = ProviderContainer(
        overrides: [
          settingsRepositoryProvider.overrideWithValue(settingsRepo),
          sessionRepositoryProvider.overrideWithValue(sessionRepo),
          homeRepositoryProvider.overrideWithValue(homeRepo),
          notesRepositoryProvider.overrideWithValue(notesRepo),
          sessionAuthNotifierProvider.overrideWith((ref) => auth),
          isOnlineProvider.overrideWithValue(false),
        ],
      );
      expect(
        () => container
            .read(settingsDiagnosticsProvider.notifier)
            .checkConnection(),
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
