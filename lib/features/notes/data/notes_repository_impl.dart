import '../../../core/error/app_failure.dart';
import '../../../core/network/api_client.dart';
import '../../../core/storage/cache_store.dart';
import '../domain/notes_repository.dart';
import '../domain/sticky_note.dart';
import 'sticky_note_dto.dart';

/// [NotesRepository] via ApiClient (api-contract.md Sticky Notes).
///
/// List TTL 60s (performance.md, state-management.md).
class NotesRepositoryImpl implements NotesRepository {
  NotesRepositoryImpl({
    required this.apiClient,
    required this.cacheStore,
    bool Function()? isOnline,
  }) : _isOnline = isOnline ?? (() => true);

  final ApiClient apiClient;
  final CacheStore cacheStore;
  final bool Function() _isOnline;

  /// Documented notes.list TTL (performance.md).
  static const Duration ttl = Duration(seconds: 60);

  static const int defaultLimit = 50;

  @override
  Future<NotesListResult> list({
    int limit = defaultLimit,
    String? cursor,
    bool force = false,
  }) async {
    final cached = await readCache();
    final online = _isOnline();

    if (!force && cached != null && cursor == null) {
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
      return await fetchFresh(limit: limit, cursor: cursor);
    } on AppFailure {
      if (cached != null && cursor == null) {
        return cached;
      }
      rethrow;
    }
  }

  @override
  Future<NotesListResult> fetchFresh({
    int limit = defaultLimit,
    String? cursor,
  }) async {
    try {
      final data = await apiClient.postAction(
        action: 'notes.list',
        payload: <String, dynamic>{
          'limit': limit,
          'cursor': cursor,
        },
      );
      final now = DateTime.now();
      final result = StickyNoteDto.fromListData(
        data,
        fetchedAt: now,
        fromCache: false,
      );
      if (cursor == null) {
        await cacheStore.write(
          StickyNoteDto.cacheKey,
          StickyNoteDto.encodeCacheEntry(payload: data, fetchedAt: now),
        );
      }
      return result;
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
  Future<NotesListResult?> readCache() async {
    final raw = await cacheStore.read(StickyNoteDto.cacheKey);
    if (raw == null || raw.isEmpty) return null;
    try {
      return StickyNoteDto.decodeCacheEntry(raw)?.result;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<StickyNote?> create({
    required String body,
    required String color,
  }) async {
    try {
      final data = await apiClient.postAction(
        action: 'notes.create',
        payload: <String, dynamic>{'body': body, 'color': color},
      );
      return StickyNoteDto.tryFromMap(data);
    } on AppFailure {
      rethrow;
    } catch (e) {
      if (e is AppFailure) rethrow;
      throw ParseFailure(message: e.toString());
    }
  }

  @override
  Future<StickyNote?> update({
    required String id,
    required String body,
    required String color,
  }) async {
    try {
      final data = await apiClient.postAction(
        action: 'notes.update',
        payload: <String, dynamic>{
          'id': id,
          'body': body,
          'color': color,
        },
      );
      return StickyNoteDto.tryFromMap(data) ??
          StickyNoteDto.tryFromMap(<String, dynamic>{
            ...data,
            'id': id,
            'body': body,
            'color': color,
          });
    } on AppFailure {
      rethrow;
    } catch (e) {
      if (e is AppFailure) rethrow;
      throw ParseFailure(message: e.toString());
    }
  }

  @override
  Future<void> delete({required String id}) async {
    try {
      await apiClient.postAction(
        action: 'notes.delete',
        payload: <String, dynamic>{'id': id},
      );
    } on AppFailure {
      rethrow;
    } catch (e) {
      if (e is AppFailure) rethrow;
      throw ParseFailure(message: e.toString());
    }
  }

  @override
  Future<void> clearCache() => cacheStore.delete(StickyNoteDto.cacheKey);
}
