import '../error/app_failure.dart';

/// Blocks mutations when offline (docs/offline.md, error-handling.md).
///
/// Notifiers call [ensureOnline] before create/update/delete/upload.
class OfflineGuard {
  const OfflineGuard(this.check);

  /// Returns current online estimate (from [isOnlineProvider] when wired).
  final bool Function() check;

  bool get isOnline => check();

  /// Throws [ValidationFailure] with code `OFFLINE_MUTATION_BLOCKED` when offline.
  void ensureOnline() {
    if (!check()) {
      throw const ValidationFailure(
        code: 'OFFLINE_MUTATION_BLOCKED',
        message: 'Butuh internet buat mengubah data.',
      );
    }
  }
}
