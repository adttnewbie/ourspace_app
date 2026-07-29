import '../../../core/error/app_failure.dart';

/// Pairing UI phase (docs/state-management.md §10, pairing-flow.md).
enum PairingPhase {
  idle,
  holding,
  submitting,
  waiting,
  paired,
  expired,
  error,
}

/// Immutable pairing controller state.
class PairingState {
  const PairingState({
    this.phase = PairingPhase.idle,
    this.nickname = '',
    this.pairingSessionId,
    this.expiresAt,
    this.holdProgress = 0,
    this.failure,
    this.secondsRemaining,
  });

  final PairingPhase phase;
  final String nickname;
  final String? pairingSessionId;
  final DateTime? expiresAt;
  final double holdProgress;
  final AppFailure? failure;
  final int? secondsRemaining;

  /// Nickname trimmed for API / validation.
  String get trimmedNickname => nickname.trim();

  /// Soft product max (screen-specs/pairing.md: 1–24).
  static const int maxNicknameLength = 24;

  bool get isNicknameValid {
    final t = trimmedNickname;
    return t.isNotEmpty && t.length <= maxNicknameLength;
  }

  bool get canStartHold =>
      isNicknameValid &&
      (phase == PairingPhase.idle || phase == PairingPhase.error);

  PairingState copyWith({
    PairingPhase? phase,
    String? nickname,
    String? pairingSessionId,
    DateTime? expiresAt,
    double? holdProgress,
    AppFailure? failure,
    int? secondsRemaining,
    bool clearPairingSessionId = false,
    bool clearExpiresAt = false,
    bool clearFailure = false,
    bool clearSecondsRemaining = false,
  }) {
    return PairingState(
      phase: phase ?? this.phase,
      nickname: nickname ?? this.nickname,
      pairingSessionId: clearPairingSessionId
          ? null
          : (pairingSessionId ?? this.pairingSessionId),
      expiresAt: clearExpiresAt ? null : (expiresAt ?? this.expiresAt),
      holdProgress: holdProgress ?? this.holdProgress,
      failure: clearFailure ? null : (failure ?? this.failure),
      secondsRemaining: clearSecondsRemaining
          ? null
          : (secondsRemaining ?? this.secondsRemaining),
    );
  }
}
