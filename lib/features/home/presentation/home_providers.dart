import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/connectivity/connectivity_providers.dart';
import '../../../core/error/app_failure.dart';
import '../../../core/network/network_providers.dart';
import '../../../core/storage/storage_providers.dart';
import '../data/home_repository_impl.dart';
import '../domain/home_repository.dart';
import '../domain/home_snapshot.dart';

/// Documented repository provider (docs/state-management.md §2).
final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  return HomeRepositoryImpl(
    apiClient: ref.watch(apiClientProvider),
    cacheStore: ref.watch(cacheStoreProvider),
    isOnline: () => ref.read(isOnlineProvider),
  );
});

/// Home snapshot + cache metadata (docs/state-management.md, screen-specs/home.md).
final homeProvider =
    AsyncNotifierProvider<HomeNotifier, HomeViewState>(HomeNotifier.new);

/// Owns home load / TTL soft-refresh / pull-to-refresh (state-management.md §7).
class HomeNotifier extends AsyncNotifier<HomeViewState> {
  var _disposed = false;

  @override
  Future<HomeViewState> build() async {
    _disposed = false;
    ref.onDispose(() => _disposed = true);

    final repo = ref.watch(homeRepositoryProvider);
    final online = ref.watch(isOnlineProvider);
    final snapshot = await repo.get(force: false);
    final age = DateTime.now().difference(snapshot.fetchedAt);
    final shouldSoftRefresh =
        online && (snapshot.fromCache || age >= HomeRepositoryImpl.ttl);

    if (shouldSoftRefresh) {
      Future.microtask(_backgroundRefresh);
      return HomeViewState(snapshot: snapshot, isRefreshing: true);
    }

    return HomeViewState(snapshot: snapshot);
  }

  /// Pull-to-refresh / retry: force network, ignore TTL.
  Future<void> refresh() async {
    final previous = state.asData?.value;
    if (previous != null) {
      state = AsyncData(
        previous.copyWith(isRefreshing: true, softWarning: false),
      );
    } else {
      state = const AsyncLoading();
    }

    final repo = ref.read(homeRepositoryProvider);
    try {
      final snapshot = await repo.fetchFresh();
      if (_disposed) return;
      state = AsyncData(HomeViewState(snapshot: snapshot));
    } on AppFailure catch (e, st) {
      if (_disposed) return;
      final cached = await repo.readCache();
      if (_disposed) return;
      if (cached != null) {
        state = AsyncData(
          HomeViewState(
            snapshot: cached,
            isRefreshing: false,
            softWarning: true,
          ),
        );
      } else if (previous != null) {
        state = AsyncData(
          previous.copyWith(isRefreshing: false, softWarning: true),
        );
      } else {
        state = AsyncError(e, st);
      }
    } catch (e, st) {
      if (_disposed) return;
      final cached = await repo.readCache();
      if (_disposed) return;
      if (cached != null) {
        state = AsyncData(
          HomeViewState(
            snapshot: cached,
            isRefreshing: false,
            softWarning: true,
          ),
        );
      } else if (previous != null) {
        state = AsyncData(
          previous.copyWith(isRefreshing: false, softWarning: true),
        );
      } else {
        state = AsyncError(e, st);
      }
    }
  }

  Future<void> _backgroundRefresh() async {
    if (_disposed) return;
    if (!ref.read(isOnlineProvider)) return;

    final previous = state.asData?.value;
    final repo = ref.read(homeRepositoryProvider);
    try {
      final snapshot = await repo.fetchFresh();
      if (_disposed) return;
      state = AsyncData(HomeViewState(snapshot: snapshot));
    } on AppFailure {
      if (_disposed) return;
      final current = state.asData?.value ?? previous;
      if (current == null) return;
      state = AsyncData(
        current.copyWith(isRefreshing: false, softWarning: true),
      );
    } catch (_) {
      if (_disposed) return;
      final current = state.asData?.value ?? previous;
      if (current == null) return;
      state = AsyncData(
        current.copyWith(isRefreshing: false, softWarning: true),
      );
    }
  }
}
