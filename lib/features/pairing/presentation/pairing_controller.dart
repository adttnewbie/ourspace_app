import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/connectivity/connectivity_providers.dart';
import '../../../core/error/app_failure.dart';
import '../../../core/error/app_log.dart';
import '../../session/presentation/session_controller.dart';
import '../domain/pairing_repository.dart';
import '../domain/pairing_result.dart';
import 'pairing_providers.dart';
import 'pairing_state.dart';

/// Poll interval while waiting (docs/state-management.md §9: 1–2s).
const Duration kPairingPollInterval = Duration(seconds: 2);

/// Brief success flash before navigate (routing.md §11).
const Duration kPairingSuccessFlash = Duration(milliseconds: 900);

/// Pairing flow owner (docs/state-management.md §2, §9–10).
class PairingController extends Notifier<PairingState> {
  Timer? _pollTimer;
  int _statusSeq = 0;
  bool _statusInFlight = false;
  bool _signalInFlight = false;

  @override
  PairingState build() {
    ref.onDispose(_cancelPoll);
    return const PairingState();
  }

  PairingRepository get _repo => ref.read(pairingRepositoryProvider);

  SessionController get _session =>
      ref.read(sessionControllerProvider.notifier);

  bool get _online => ref.read(isOnlineProvider);

  void setNickname(String value) {
    if (state.phase == PairingPhase.waiting ||
        state.phase == PairingPhase.submitting ||
        state.phase == PairingPhase.paired ||
        state.phase == PairingPhase.holding) {
      return;
    }
    state = state.copyWith(
      nickname: value,
      clearFailure: true,
      phase: state.phase == PairingPhase.error
          ? PairingPhase.idle
          : state.phase,
    );
  }

  /// Pointer down on hold button (screen-specs/pairing.md).
  void beginHold() {
    if (!_online) {
      state = state.copyWith(
        phase: PairingPhase.error,
        failure: const ValidationFailure(
          code: 'OFFLINE_MUTATION_BLOCKED',
          message: 'Butuh internet buat pairing dulu ya.',
        ),
        holdProgress: 0,
      );
      return;
    }
    if (!state.canStartHold || _signalInFlight) return;
    state = state.copyWith(
      phase: PairingPhase.holding,
      holdProgress: 0,
      clearFailure: true,
    );
  }

  /// Animation progress 0–1 while holding.
  void updateHoldProgress(double progress) {
    if (state.phase != PairingPhase.holding) return;
    state = state.copyWith(holdProgress: progress.clamp(0.0, 1.0));
  }

  /// Pointer up before 3s complete — cancel, no API.
  void cancelHold() {
    if (state.phase != PairingPhase.holding) return;
    state = state.copyWith(phase: PairingPhase.idle, holdProgress: 0);
  }

  /// Hold completed 3s → start (if needed) then signal.
  Future<void> completeHold() async {
    if (state.phase != PairingPhase.holding) return;
    if (!_online) {
      state = state.copyWith(
        phase: PairingPhase.error,
        failure: const ValidationFailure(
          code: 'OFFLINE_MUTATION_BLOCKED',
          message: 'Butuh internet buat pairing dulu ya.',
        ),
        holdProgress: 0,
      );
      return;
    }
    if (!state.isNicknameValid || _signalInFlight) {
      state = state.copyWith(phase: PairingPhase.idle, holdProgress: 0);
      return;
    }

    _signalInFlight = true;
    state = state.copyWith(
      phase: PairingPhase.submitting,
      holdProgress: 1,
      clearFailure: true,
    );

    final nickname = state.trimmedNickname;

    try {
      var sessionId = state.pairingSessionId;
      if (sessionId == null || sessionId.isEmpty) {
        final started = await _repo.start(nickname: nickname);
        if (!_alive) return;
        switch (started) {
          case PairingWaiting(:final pairingSessionId, :final expiresAt):
            sessionId = pairingSessionId;
            state = state.copyWith(
              pairingSessionId: pairingSessionId,
              expiresAt: expiresAt,
              secondsRemaining: _secondsLeft(expiresAt),
            );
          case PairingPaired():
            await _handlePaired(started);
            return;
          case PairingExpiredResult():
            _enterExpired();
            return;
        }
      }

      final id = sessionId;
      if (id.isEmpty) {
        throw const ValidationFailure(message: 'pairingSessionId missing');
      }
      final result = await _repo.signal(
        pairingSessionId: id,
        nickname: nickname,
      );
      if (!_alive) return;
      await _applyResult(result, keepSessionId: id);
    } on AppFailure catch (e) {
      if (!_alive) return;
      _handleFailure(e);
    } catch (e) {
      if (!_alive) return;
      AppLog.e('pairing.completeHold', e);
      _handleFailure(ParseFailure(message: e.toString()));
    } finally {
      _signalInFlight = false;
    }
  }

  /// Retry after expired / error (new window).
  void retry() {
    _cancelPoll();
    _statusInFlight = false;
    _signalInFlight = false;
    state = PairingState(nickname: state.nickname);
  }

  Future<void> _applyResult(
    PairingResult result, {
    required String keepSessionId,
  }) async {
    switch (result) {
      case PairingWaiting(:final pairingSessionId, :final expiresAt):
        final alreadyWaiting = state.phase == PairingPhase.waiting;
        state = state.copyWith(
          phase: PairingPhase.waiting,
          pairingSessionId: pairingSessionId.isNotEmpty
              ? pairingSessionId
              : keepSessionId,
          expiresAt: expiresAt,
          holdProgress: 0,
          secondsRemaining: _secondsLeft(expiresAt),
          clearFailure: true,
        );
        if (!alreadyWaiting) {
          _startPoll();
        }
      case PairingPaired():
        await _handlePaired(result);
      case PairingExpiredResult():
        _enterExpired();
    }
  }

  Future<void> _handlePaired(PairingPaired paired) async {
    _cancelPoll();
    state = state.copyWith(
      phase: PairingPhase.paired,
      holdProgress: 0,
      clearFailure: true,
      clearSecondsRemaining: true,
      clearPairingSessionId: true,
      clearExpiresAt: true,
    );
    try {
      await _session.applyPairedSession(
        memberId: paired.memberId,
        sessionToken: paired.sessionToken,
        anniversaryDate: paired.anniversaryDate,
        members: paired.members,
      );
    } on AppFailure catch (e) {
      if (!_alive) return;
      _handleFailure(e);
    } catch (e) {
      if (!_alive) return;
      AppLog.e('pairing.applyPairedSession', e);
      _handleFailure(ParseFailure(message: e.toString()));
    }
  }

  void _enterExpired() {
    _cancelPoll();
    state = state.copyWith(
      phase: PairingPhase.expired,
      holdProgress: 0,
      clearPairingSessionId: true,
      clearExpiresAt: true,
      clearSecondsRemaining: true,
      clearFailure: true,
    );
  }

  void _handleFailure(AppFailure e) {
    _cancelPoll();
    if (e.code == 'PAIRING_EXPIRED') {
      _enterExpired();
      return;
    }
    state = state.copyWith(
      phase: PairingPhase.error,
      failure: e,
      holdProgress: 0,
      clearPairingSessionId: e.code == 'BAD_REQUEST',
    );
  }

  void _startPoll() {
    _cancelPoll();
    _pollTimer = Timer.periodic(kPairingPollInterval, (_) {
      unawaited(_pollOnce());
    });
    unawaited(_pollOnce());
  }

  Future<void> _pollOnce() async {
    if (state.phase != PairingPhase.waiting) return;
    if (!_online) return;
    final sessionId = state.pairingSessionId;
    if (sessionId == null || sessionId.isEmpty) return;
    if (_statusInFlight) return;

    final expiresAt = state.expiresAt;
    if (expiresAt != null) {
      final left = _secondsLeft(expiresAt);
      state = state.copyWith(secondsRemaining: left);
      if (left <= 0) {
        _enterExpired();
        return;
      }
    }

    _statusInFlight = true;
    final seq = ++_statusSeq;
    try {
      final result = await _repo.status(pairingSessionId: sessionId);
      if (!_alive || seq != _statusSeq) return;
      if (state.phase != PairingPhase.waiting) return;
      await _applyResult(result, keepSessionId: sessionId);
    } on AppFailure catch (e) {
      if (!_alive || seq != _statusSeq) return;
      if (e.code == 'PAIRING_EXPIRED') {
        _enterExpired();
        return;
      }
      // Soft network errors: keep waiting; countdown continues.
      if (e is NetworkFailure) {
        AppLog.w('pairing.status network', e.code);
        return;
      }
      _handleFailure(e);
    } catch (e) {
      if (!_alive || seq != _statusSeq) return;
      AppLog.e('pairing.status', e);
    } finally {
      if (seq == _statusSeq) {
        _statusInFlight = false;
      }
    }
  }

  int _secondsLeft(DateTime expiresAt) {
    final left = expiresAt.difference(DateTime.now()).inSeconds;
    return left < 0 ? 0 : left;
  }

  void _cancelPoll() {
    _pollTimer?.cancel();
    _pollTimer = null;
  }

  bool get _alive {
    try {
      ref.read(pairingRepositoryProvider);
      return true;
    } catch (_) {
      return false;
    }
  }
}

/// Documented pairing owner (docs/state-management.md).
final pairingControllerProvider =
    NotifierProvider<PairingController, PairingState>(PairingController.new);
