import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/network_providers.dart';
import '../data/pairing_repository_impl.dart';
import '../domain/pairing_repository.dart';

/// Documented repository provider (docs/state-management.md §2).
final pairingRepositoryProvider = Provider<PairingRepository>((ref) {
  return PairingRepositoryImpl(apiClient: ref.watch(apiClientProvider));
});
