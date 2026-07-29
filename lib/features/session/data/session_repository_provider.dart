import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/network_providers.dart';
import '../../../core/storage/storage_providers.dart';
import '../domain/session_repository.dart';
import 'session_repository_impl.dart';

/// Documented repository provider (docs/state-management.md).
final sessionRepositoryProvider = Provider<SessionRepository>((ref) {
  return SessionRepositoryImpl(
    apiClient: ref.watch(apiClientProvider),
    secureStorage: ref.watch(secureStorageProvider),
  );
});
