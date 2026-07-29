import '../../../core/error/app_failure.dart';
import '../../../core/network/api_client.dart';
import '../domain/notes_repository.dart';

/// [NotesRepository] via ApiClient (api-contract.md Sticky Notes).
class NotesRepositoryImpl implements NotesRepository {
  NotesRepositoryImpl({required this.apiClient});

  final ApiClient apiClient;

  @override
  Future<void> create({
    required String body,
    required String color,
  }) async {
    try {
      await apiClient.postAction(
        action: 'notes.create',
        payload: <String, dynamic>{'body': body, 'color': color},
      );
    } on AppFailure {
      rethrow;
    } catch (e) {
      throw ParseFailure(message: e.toString());
    }
  }
}
