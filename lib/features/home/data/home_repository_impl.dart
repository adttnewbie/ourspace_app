import '../../../core/error/app_failure.dart';
import '../../../core/network/api_client.dart';
import '../../../core/storage/cache_store.dart';
import '../domain/home_repository.dart';
import '../domain/home_snapshot.dart';
import 'home_dto.dart';

/// [HomeRepository] with 45s TTL cache (docs/performance.md, state-management.md).
class HomeRepositoryImpl implements HomeRepository {
  HomeRepositoryImpl({
    required this.apiClient,
    required this.cacheStore,
    bool Function()? isOnline,
  }) : _isOnline = isOnline ?? (() => true);

  final ApiClient apiClient;
  final CacheStore cacheStore;
  final bool Function() _isOnline;

  /// Documented home.get TTL (performance.md).
  static const Duration ttl = Duration(seconds: 45);

  @override
  Future<HomeSnapshot> get({bool force = false}) async {
    final cached = await readCache();
    final online = _isOnline();

    if (!force && cached != null) {
      final age = DateTime.now().difference(cached.fetchedAt);
      if (age < ttl) {
        return cached;
      }
      if (!online) {
        return cached;
      }
    }

    if (!online) {
      if (cached != null) {
        return cached;
      }
      throw const NetworkFailure(code: 'NETWORK_OFFLINE');
    }

    try {
      return await fetchFresh();
    } on AppFailure {
      if (cached != null) {
        return cached;
      }
      rethrow;
    }
  }

  @override
  Future<HomeSnapshot> fetchFresh() async {
    try {
      final data = await apiClient.postAction(
        action: 'home.get',
        payload: const <String, dynamic>{},
      );
      final now = DateTime.now();
      final snapshot = HomeDto.fromGetData(
        data,
        fetchedAt: now,
        fromCache: false,
      );
      await cacheStore.write(
        HomeDto.cacheKey,
        HomeDto.encodeCacheEntry(payload: data, fetchedAt: now),
      );
      return snapshot;
    } on AppFailure {
      rethrow;
    } on FormatException catch (e) {
      throw ParseFailure(message: e.message);
    } catch (e) {
      if (e is AppFailure) rethrow;
      throw ParseFailure(message: e.toString());
    }
  }

  @override
  Future<HomeSnapshot?> readCache() async {
    final raw = await cacheStore.read(HomeDto.cacheKey);
    if (raw == null || raw.isEmpty) return null;
    try {
      final decoded = HomeDto.decodeCacheEntry(raw);
      return decoded?.snapshot;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> clearCache() => cacheStore.delete(HomeDto.cacheKey);
}
