import 'session_snapshot.dart';

/// Session aggregate access (docs/state-management.md §12).
abstract class SessionRepository {
  /// Validates secure-storage credentials via `session.resume`.
  ///
  /// Throws [AppFailure] on API/network/parse errors.
  /// Returns `null` when local tokens are missing (unauthenticated).
  Future<SessionSnapshot?> resume({bool force = false});

  /// Deletes `memberId` + `sessionToken` from secure storage.
  Future<void> clearLocal();

  /// Whether both session keys exist in secure storage.
  Future<bool> hasLocalCredentials();
}
