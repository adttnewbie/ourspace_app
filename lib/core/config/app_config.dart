/// Client configuration from `--dart-define` / `--dart-define-from-file`.
///
/// See [docs/environment.md]. Canonical base URL name: `API_BASE_URL`.
class AppConfig {
  AppConfig._();

  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: '',
  );

  static const String appEnv = String.fromEnvironment(
    'APP_ENV',
    defaultValue: 'dev',
  );

  static const String logLevel = String.fromEnvironment(
    'LOG_LEVEL',
    defaultValue: 'info',
  );

  /// Fail fast when `API_BASE_URL` is missing (debug DoD 1.2; release too).
  static void ensureInitialized() {
    if (apiBaseUrl.isEmpty) {
      throw StateError(
        'API_BASE_URL is missing or empty.\n'
        'Pass it at run/build time, for example:\n'
        '  flutter run --dart-define=API_BASE_URL=https://script.google.com/macros/s/DEV_ID/exec\n'
        '  flutter run --dart-define-from-file=env/dev.json\n'
        'See docs/environment.md and env.example.json.',
      );
    }
  }
}
