import '../../../core/error/app_failure.dart';
import '../../../core/network/api_client.dart';
import '../../../core/storage/secure_storage.dart';
import '../../../core/storage/storage_keys.dart';
import '../domain/session_repository.dart';
import '../domain/session_snapshot.dart';
import 'session_dto.dart';

/// [SessionRepository] backed by secure storage + ApiClient.
class SessionRepositoryImpl implements SessionRepository {
  SessionRepositoryImpl({
    required this._apiClient,
    required this._secureStorage,
  });

  final ApiClient _apiClient;
  final SecureStorage _secureStorage;

  @override
  Future<bool> hasLocalCredentials() async {
    final memberId = await _secureStorage.read(StorageKeys.memberId);
    final sessionToken = await _secureStorage.read(StorageKeys.sessionToken);
    return memberId != null &&
        memberId.isNotEmpty &&
        sessionToken != null &&
        sessionToken.isNotEmpty;
  }

  @override
  Future<SessionSnapshot?> resume({bool force = false}) async {
    final has = await hasLocalCredentials();
    if (!has) return null;

    try {
      final data = await _apiClient.postAction(
        action: 'session.resume',
        payload: const <String, dynamic>{},
      );
      return SessionDto.fromResumeData(data);
    } on AppFailure {
      rethrow;
    } on FormatException catch (e) {
      throw ParseFailure(message: e.message);
    } catch (e) {
      throw ParseFailure(message: e.toString());
    }
  }

  @override
  Future<void> writeLocal({
    required String memberId,
    required String sessionToken,
  }) async {
    await _secureStorage.write(StorageKeys.memberId, memberId);
    await _secureStorage.write(StorageKeys.sessionToken, sessionToken);
  }

  @override
  Future<void> clearLocal() async {
    await _secureStorage.delete(StorageKeys.memberId);
    await _secureStorage.delete(StorageKeys.sessionToken);
  }
}
