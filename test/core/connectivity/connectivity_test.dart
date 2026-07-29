import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ourspace_app/core/connectivity/connectivity_providers.dart';
import 'package:ourspace_app/core/connectivity/connectivity_repository.dart';
import 'package:ourspace_app/core/connectivity/offline_guard.dart';
import 'package:ourspace_app/core/error/app_failure.dart';

void main() {
  group('ConnectivityPlusRepository.isOnlineFromResults', () {
    test('empty_or_none_isOffline', () {
      expect(ConnectivityPlusRepository.isOnlineFromResults(const []), isFalse);
      expect(
        ConnectivityPlusRepository.isOnlineFromResults(const [
          ConnectivityResult.none,
        ]),
        isFalse,
      );
    });

    test('wifi_or_mobile_isOnline', () {
      expect(
        ConnectivityPlusRepository.isOnlineFromResults(const [
          ConnectivityResult.wifi,
        ]),
        isTrue,
      );
      expect(
        ConnectivityPlusRepository.isOnlineFromResults(const [
          ConnectivityResult.mobile,
        ]),
        isTrue,
      );
    });
  });

  group('OfflineGuard', () {
    test('ensureOnline_whenOnline_doesNotThrow', () {
      const guard = OfflineGuard(_alwaysOnline);
      expect(guard.ensureOnline, returnsNormally);
    });

    test('ensureOnline_whenOffline_throwsOfflineMutationBlocked', () {
      const guard = OfflineGuard(_alwaysOffline);
      expect(
        guard.ensureOnline,
        throwsA(
          isA<ValidationFailure>().having(
            (f) => f.code,
            'code',
            'OFFLINE_MUTATION_BLOCKED',
          ),
        ),
      );
    });
  });

  group('isOnlineProvider + OfflineGuard from notifiers', () {
    test('offlineGuard_callable_viaProviderContainer', () async {
      final fake = FakeConnectivityRepository(online: true);
      final container = ProviderContainer(
        overrides: [connectivityRepositoryProvider.overrideWithValue(fake)],
      );
      addTearDown(() async {
        container.dispose();
        await fake.dispose();
      });

      await container.read(connectivityProvider.future);
      expect(container.read(isOnlineProvider), isTrue);
      expect(
        container.read(offlineGuardProvider).ensureOnline,
        returnsNormally,
      );

      fake.setOnline(false);
      // watchOnline is a new async* subscription per listen; force re-read
      // via repository direct + override isOnlineProvider for guard check.
      expect(await fake.isOnline(), isFalse);

      final offlineContainer = ProviderContainer(
        overrides: [
          connectivityRepositoryProvider.overrideWithValue(fake),
          isOnlineProvider.overrideWithValue(false),
        ],
      );
      addTearDown(offlineContainer.dispose);

      expect(offlineContainer.read(isOnlineProvider), isFalse);
      expect(
        offlineContainer.read(offlineGuardProvider).ensureOnline,
        throwsA(
          isA<ValidationFailure>().having(
            (f) => f.code,
            'code',
            'OFFLINE_MUTATION_BLOCKED',
          ),
        ),
      );
    });
  });
}

bool _alwaysOnline() => true;
bool _alwaysOffline() => false;
