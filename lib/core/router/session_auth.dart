import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../storage/secure_storage.dart';
import '../storage/storage_keys.dart';
import '../storage/storage_providers.dart';

/// Session navigation states (docs/routing.md §6).
///
/// Step 1.8: presence of secure keys only — no session.resume (Phase 2.1).
enum SessionAuthStatus { unknown, unauthenticated, authenticated }

/// Listenable auth snapshot for [GoRouter.refreshListenable].
class SessionAuthNotifier extends ChangeNotifier {
  SessionAuthNotifier(this._secureStorage);

  final SecureStorage _secureStorage;
  SessionAuthStatus _status = SessionAuthStatus.unknown;

  SessionAuthStatus get status => _status;

  /// Probe secure storage for memberId + sessionToken (fake auth until 2.1).
  Future<void> resolveFromStorage() async {
    final memberId = await _secureStorage.read(StorageKeys.memberId);
    final sessionToken = await _secureStorage.read(StorageKeys.sessionToken);
    final hasSession =
        memberId != null &&
        memberId.isNotEmpty &&
        sessionToken != null &&
        sessionToken.isNotEmpty;
    setStatus(
      hasSession
          ? SessionAuthStatus.authenticated
          : SessionAuthStatus.unauthenticated,
    );
  }

  /// Test / DoD override: force auth without real session product.
  void setStatus(SessionAuthStatus value) {
    if (_status == value) return;
    _status = value;
    notifyListeners();
  }
}

final sessionAuthNotifierProvider = Provider<SessionAuthNotifier>((ref) {
  final storage = ref.watch(secureStorageProvider);
  final notifier = SessionAuthNotifier(storage);
  ref.onDispose(notifier.dispose);
  notifier.resolveFromStorage();
  return notifier;
});
