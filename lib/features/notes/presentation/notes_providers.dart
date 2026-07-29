import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/network_providers.dart';
import '../data/notes_repository_impl.dart';
import '../domain/notes_repository.dart';

/// Documented repository provider (docs/state-management.md §2).
final notesRepositoryProvider = Provider<NotesRepository>((ref) {
  return NotesRepositoryImpl(apiClient: ref.watch(apiClientProvider));
});
