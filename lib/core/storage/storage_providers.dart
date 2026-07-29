import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'cache_store.dart';
import 'secure_storage.dart';

/// Documented dependency provider (docs/state-management.md, coding-standard.md).
final secureStorageProvider = Provider<SecureStorage>((ref) {
  return FlutterSecureStorageStore();
});

/// Non-sensitive cache primitive (memory default; prefs impl via override/create).
final cacheStoreProvider = Provider<CacheStore>((ref) {
  return InMemoryCacheStore();
});
