import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/connectivity/connectivity_providers.dart';
import '../../../core/error/app_failure.dart';
import '../../../core/network/network_providers.dart';
import '../../../core/storage/storage_providers.dart';
import '../../home/presentation/home_providers.dart';
import '../data/notes_repository_impl.dart';
import '../domain/notes_repository.dart';
import '../domain/sticky_note.dart';
import 'notes_list_state.dart';

/// Documented repository provider (docs/state-management.md §2).
final notesRepositoryProvider = Provider<NotesRepository>((ref) {
  return NotesRepositoryImpl(
    apiClient: ref.watch(apiClientProvider),
    cacheStore: ref.watch(cacheStoreProvider),
    isOnline: () => ref.read(isOnlineProvider),
  );
});

/// Notes list + cache metadata (docs/state-management.md, screen-specs/notes.md).
final notesListProvider =
    AsyncNotifierProvider<NotesListNotifier, NotesListViewState>(
      NotesListNotifier.new,
    );

/// Owns notes list load / TTL soft-refresh / mutations (state-management.md §5–7).
class NotesListNotifier extends AsyncNotifier<NotesListViewState> {
  var _disposed = false;

  @override
  Future<NotesListViewState> build() async {
    _disposed = false;
    ref.onDispose(() => _disposed = true);

    final repo = ref.watch(notesRepositoryProvider);
    final online = ref.watch(isOnlineProvider);
    final result = await repo.list(force: false);
    final age = DateTime.now().difference(result.fetchedAt);
    final shouldSoftRefresh =
        online && (result.fromCache || age >= NotesRepositoryImpl.ttl);

    if (shouldSoftRefresh) {
      Future.microtask(_backgroundRefresh);
      return NotesListViewState(result: result, isRefreshing: true);
    }

    return NotesListViewState(result: result);
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

    final repo = ref.read(notesRepositoryProvider);
    try {
      final result = await repo.fetchFresh();
      if (_disposed) return;
      state = AsyncData(NotesListViewState(result: result));
    } on AppFailure catch (e, st) {
      if (_disposed) return;
      await _failWithCacheOrError(previous, e, st);
    } catch (e, st) {
      if (_disposed) return;
      await _failWithCacheOrError(previous, e, st);
    }
  }

  /// Create sticky (screen-specs/notes.md). Patches list + invalidates home.
  Future<void> create({required String body, required String color}) async {
    ref.read(offlineGuardProvider).ensureOnline();
    final repo = ref.read(notesRepositoryProvider);
    final created = await repo.create(body: body, color: color);
    if (_disposed) return;

    if (created != null) {
      _patchInsert(created);
    } else {
      await _reloadAfterMutation();
    }
    _invalidateHome();
  }

  /// Update sticky. Owner enforced by server.
  ///
  /// Named [updateNote] to avoid clashing with [AsyncNotifier.update].
  Future<void> updateNote({
    required String id,
    required String body,
    required String color,
  }) async {
    ref.read(offlineGuardProvider).ensureOnline();
    final repo = ref.read(notesRepositoryProvider);
    final updated = await repo.update(id: id, body: body, color: color);
    if (_disposed) return;

    if (updated != null) {
      _patchReplace(updated);
    } else {
      final previous = state.asData?.value;
      if (previous != null) {
        final patched = previous.items.map((n) {
          if (n.id != id) return n;
          return n.copyWith(
            body: body,
            color: color,
            updatedAt: DateTime.now(),
          );
        }).toList();
        state = AsyncData(
          previous.copyWith(
            result: previous.result.copyWith(items: patched),
            isRefreshing: false,
            softWarning: false,
          ),
        );
      } else {
        await _reloadAfterMutation();
      }
    }
    _invalidateHome();
  }

  /// Soft-delete sticky. Removes from local list on success.
  Future<void> remove({required String id}) async {
    ref.read(offlineGuardProvider).ensureOnline();
    final repo = ref.read(notesRepositoryProvider);
    await repo.delete(id: id);
    if (_disposed) return;
    _patchRemove(id);
    _invalidateHome();
  }

  void _patchInsert(StickyNote note) {
    final previous = state.asData?.value;
    if (previous == null) {
      Future.microtask(_reloadAfterMutation);
      return;
    }
    final items = <StickyNote>[note, ...previous.items.where((n) => n.id != note.id)];
    state = AsyncData(
      previous.copyWith(
        result: previous.result.copyWith(items: items),
        isRefreshing: false,
        softWarning: false,
      ),
    );
  }

  void _patchReplace(StickyNote note) {
    final previous = state.asData?.value;
    if (previous == null) {
      Future.microtask(_reloadAfterMutation);
      return;
    }
    final items = previous.items.map((n) => n.id == note.id ? note : n).toList();
    state = AsyncData(
      previous.copyWith(
        result: previous.result.copyWith(items: items),
        isRefreshing: false,
        softWarning: false,
      ),
    );
  }

  void _patchRemove(String id) {
    final previous = state.asData?.value;
    if (previous == null) return;
    final items = previous.items.where((n) => n.id != id).toList();
    state = AsyncData(
      previous.copyWith(
        result: previous.result.copyWith(items: items),
        isRefreshing: false,
        softWarning: false,
      ),
    );
  }

  Future<void> _reloadAfterMutation() async {
    final repo = ref.read(notesRepositoryProvider);
    try {
      final result = await repo.fetchFresh();
      if (_disposed) return;
      state = AsyncData(NotesListViewState(result: result));
    } catch (_) {
      // Keep prior list if refresh fails after successful mutation.
    }
  }

  void _invalidateHome() {
    try {
      ref.invalidate(homeProvider);
    } catch (_) {}
  }

  Future<void> _backgroundRefresh() async {
    if (_disposed) return;
    if (!ref.read(isOnlineProvider)) return;

    final previous = state.asData?.value;
    final repo = ref.read(notesRepositoryProvider);
    try {
      final result = await repo.fetchFresh();
      if (_disposed) return;
      state = AsyncData(NotesListViewState(result: result));
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

  Future<void> _failWithCacheOrError(
    NotesListViewState? previous,
    Object e,
    StackTrace st,
  ) async {
    final repo = ref.read(notesRepositoryProvider);
    final cached = await repo.readCache();
    if (_disposed) return;
    if (cached != null) {
      state = AsyncData(
        NotesListViewState(
          result: cached,
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

/// Draft body/color for note editor dialog (docs/state-management.md).
final noteEditorControllerProvider =
    NotifierProvider<NoteEditorController, NoteEditorState>(
      NoteEditorController.new,
    );

class NoteEditorController extends Notifier<NoteEditorState> {
  @override
  NoteEditorState build() => const NoteEditorState();

  void startCreate({String color = 'pink'}) {
    state = NoteEditorState(body: '', color: color);
  }

  void startEdit(StickyNote note) {
    state = NoteEditorState(
      noteId: note.id,
      body: note.body,
      color: note.color,
    );
  }

  void setBody(String body) {
    state = state.copyWith(body: body);
  }

  void setColor(String color) {
    state = state.copyWith(color: color);
  }

  void setSubmitting(bool value) {
    state = state.copyWith(isSubmitting: value);
  }

  void reset() {
    state = const NoteEditorState();
  }
}
