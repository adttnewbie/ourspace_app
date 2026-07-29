import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/network_providers.dart';
import '../../../core/storage/storage_providers.dart';
import '../data/session_repository_impl.dart';
import '../domain/session_repository.dart';

/// Documented repository provider (docs/state-management.md).
///
/// Kept free of [SessionController] imports to avoid circular deps.
final sessionRepositoryProvider = Provider<SessionRepository>((ref) {
  return SessionRepositoryImpl(
    apiClient: ref.watch(apiClientProvider),
    secureStorage: ref.watch(secureStorageProvider),
  );
});
