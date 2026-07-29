import 'home_snapshot.dart';

/// Home aggregate access (docs/state-management.md §12).
abstract class HomeRepository {
  /// Loads with TTL: fresh cache hit, else network; offline may return stale cache.
  Future<HomeSnapshot> get({bool force = false});

  /// Network-only fetch; writes cache. Throws [AppFailure] on failure.
  Future<HomeSnapshot> fetchFresh();

  /// Last cached snapshot if any (TTL ignored).
  Future<HomeSnapshot?> readCache();

  /// Clears local home cache (session clear / UNAUTHORIZED).
  Future<void> clearCache();
}
