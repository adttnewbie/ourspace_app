import '../../../core/error/app_failure.dart';
import '../../../core/network/api_client.dart';
import '../domain/settings_repository.dart';

/// [SettingsRepository] via ApiClient (api-contract.md Health / diagnostics).
class SettingsRepositoryImpl implements SettingsRepository {
  SettingsRepositoryImpl({required this.apiClient});

  final ApiClient apiClient;

  @override
  Future<void> checkHealth() async {
    try {
      await apiClient.postAction(
        action: 'health.check',
        payload: <String, dynamic>{},
      );
    } on AppFailure {
      rethrow;
    } catch (e) {
      throw ParseFailure(message: e.toString());
    }
  }
}
