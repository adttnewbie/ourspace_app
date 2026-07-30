/// Ephemeral last diagnostics result (docs/state-management.md settingsDiagnosticsProvider).
///
/// Never holds tokens or secrets (security.md, screen-specs/settings.md).
class SettingsDiagnosticsState {
  const SettingsDiagnosticsState({
    this.lastMessage,
    this.lastOk,
    this.isCheckingConnection = false,
    this.isCheckingSession = false,
    this.isClearingSession = false,
  });

  /// Human-readable last check summary (no secrets).
  final String? lastMessage;

  /// True if last check succeeded; false if failed; null if never run.
  final bool? lastOk;

  final bool isCheckingConnection;
  final bool isCheckingSession;
  final bool isClearingSession;

  bool get isBusy =>
      isCheckingConnection || isCheckingSession || isClearingSession;

  SettingsDiagnosticsState copyWith({
    String? lastMessage,
    bool? lastOk,
    bool? isCheckingConnection,
    bool? isCheckingSession,
    bool? isClearingSession,
    bool clearMessage = false,
  }) {
    return SettingsDiagnosticsState(
      lastMessage: clearMessage ? null : (lastMessage ?? this.lastMessage),
      lastOk: clearMessage ? null : (lastOk ?? this.lastOk),
      isCheckingConnection:
          isCheckingConnection ?? this.isCheckingConnection,
      isCheckingSession: isCheckingSession ?? this.isCheckingSession,
      isClearingSession: isClearingSession ?? this.isClearingSession,
    );
  }
}
