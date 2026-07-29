import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

/// Domain-agnostic online/offline source (docs/offline.md, implementation-order 1.7).
abstract class ConnectivityRepository {
  /// Current online estimate (any non-[ConnectivityResult.none] link).
  Future<bool> isOnline();

  /// Stream of online estimates; emits on link changes.
  Stream<bool> watchOnline();
}

/// [connectivity_plus] implementation.
class ConnectivityPlusRepository implements ConnectivityRepository {
  ConnectivityPlusRepository({Connectivity? connectivity})
    : _connectivity = connectivity ?? Connectivity();

  final Connectivity _connectivity;

  @override
  Future<bool> isOnline() async {
    final results = await _connectivity.checkConnectivity();
    return isOnlineFromResults(results);
  }

  @override
  Stream<bool> watchOnline() {
    return _connectivity.onConnectivityChanged.map(isOnlineFromResults);
  }

  /// Pure mapping for unit tests (no platform channel).
  static bool isOnlineFromResults(List<ConnectivityResult> results) {
    if (results.isEmpty) return false;
    return results.any((r) => r != ConnectivityResult.none);
  }
}

/// Controllable fake for tests / provider overrides.
class FakeConnectivityRepository implements ConnectivityRepository {
  FakeConnectivityRepository({this.online = true});

  bool online;
  final StreamController<bool> _controller = StreamController<bool>.broadcast();

  void setOnline(bool value) {
    if (online == value) return;
    online = value;
    _controller.add(value);
  }

  @override
  Future<bool> isOnline() async => online;

  @override
  Stream<bool> watchOnline() async* {
    yield online;
    yield* _controller.stream;
  }

  Future<void> dispose() => _controller.close();
}
