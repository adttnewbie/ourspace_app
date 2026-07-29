import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Session navigation states (docs/routing.md §6).
enum SessionAuthStatus {
  unknown,
  unauthenticated,
  authenticated,
  temporaryError,
}

/// Listenable auth snapshot for [GoRouter.refreshListenable].
///
/// Owned by [SessionController] via [setStatus] (step 2.1).
class SessionAuthNotifier extends ChangeNotifier {
  SessionAuthStatus _status = SessionAuthStatus.unknown;

  SessionAuthStatus get status => _status;

  /// Updates redirect snapshot; no-op if unchanged.
  void setStatus(SessionAuthStatus value) {
    if (_status == value) return;
    _status = value;
    notifyListeners();
  }
}

final sessionAuthNotifierProvider = Provider<SessionAuthNotifier>((ref) {
  final notifier = SessionAuthNotifier();
  ref.onDispose(notifier.dispose);
  return notifier;
});
