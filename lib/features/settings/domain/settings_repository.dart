/// Settings diagnostics API access (docs/state-management.md §12).
abstract class SettingsRepository {
  /// Backend reachability via `health.check` (api-contract.md, screen-specs/settings.md).
  Future<void> checkHealth();
}
