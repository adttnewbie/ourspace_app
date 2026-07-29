import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'connectivity_repository.dart';
import 'offline_guard.dart';

/// Connectivity repository dependency (docs/state-management.md).
final connectivityRepositoryProvider = Provider<ConnectivityRepository>((ref) {
  return ConnectivityPlusRepository();
});

/// Online/offline stream for UI + notifiers (docs/state-management.md).
final connectivityProvider = StreamProvider<bool>((ref) {
  final repo = ref.watch(connectivityRepositoryProvider);
  return repo.watchOnline();
});

/// Derived bool for guards (docs/coding-standard.md, implementation-order 1.7).
///
/// Defaults to `true` while the first connectivity event is loading so cold
/// start does not false-block mutations before the platform reports.
final isOnlineProvider = Provider<bool>((ref) {
  return ref
      .watch(connectivityProvider)
      .maybeWhen(data: (online) => online, orElse: () => true);
});

/// Offline mutation guard callable from notifiers (DoD 1.7).
final offlineGuardProvider = Provider<OfflineGuard>((ref) {
  return OfflineGuard(() => ref.read(isOnlineProvider));
});
