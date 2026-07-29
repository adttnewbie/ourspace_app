import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/error/app_failure.dart';
import '../../../core/router/session_auth.dart';
import '../domain/member.dart';
import '../domain/session_repository.dart';
import '../domain/session_snapshot.dart';
import 'session_providers.dart';

/// In-memory resume TTL (docs/performance.md, state-management.md: 30–60s).
const Duration kSessionResumeTtl = Duration(seconds: 45);

/// Session lifecycle owner (docs/state-management.md, routing.md SessionGate).
class SessionController extends Notifier<SessionControllerState> {
  @override
  SessionControllerState build() => const SessionControllerState.unknown();

  SessionRepository get _repo => ref.read(sessionRepositoryProvider);

  SessionAuthNotifier get _auth => ref.read(sessionAuthNotifierProvider);

  /// Cold start / gate: read storage → resume if tokens present.
  ///
  /// Called from [routerProvider] once at app bootstrap (not from [build]).
  Future<void> bootstrap() => resume(force: false);

  /// Validates session. [force] bypasses in-memory TTL.
  Future<void> resume({bool force = false}) async {
    final current = state;
    if (!force &&
        current.status == SessionPhase.authenticated &&
        current.snapshot != null &&
        DateTime.now().difference(current.snapshot!.fetchedAt) <
            kSessionResumeTtl) {
      _setAuth(SessionAuthStatus.authenticated);
      return;
    }

    _apply(const SessionControllerState.unknown(), SessionAuthStatus.unknown);

    final has = await _repo.hasLocalCredentials();
    if (!_alive) return;

    if (!has) {
      _apply(
        const SessionControllerState.unauthenticated(),
        SessionAuthStatus.unauthenticated,
      );
      return;
    }

    try {
      final snapshot = await _repo.resume(force: force);
      if (!_alive) return;

      if (snapshot == null) {
        _apply(
          const SessionControllerState.unauthenticated(),
          SessionAuthStatus.unauthenticated,
        );
        return;
      }
      _apply(
        SessionControllerState.authenticated(snapshot),
        SessionAuthStatus.authenticated,
      );
    } on ApiFailure catch (e) {
      if (!_alive) return;
      if (e.code == 'UNAUTHORIZED') {
        await _repo.clearLocal();
        if (!_alive) return;
        _apply(
          const SessionControllerState.unauthenticated(),
          SessionAuthStatus.unauthenticated,
        );
        return;
      }
      _apply(
        SessionControllerState.temporaryError(e),
        SessionAuthStatus.temporaryError,
      );
    } on NetworkFailure catch (e) {
      if (!_alive) return;
      _apply(
        SessionControllerState.temporaryError(e),
        SessionAuthStatus.temporaryError,
      );
    } on AppFailure catch (e) {
      if (!_alive) return;
      _apply(
        SessionControllerState.temporaryError(e),
        SessionAuthStatus.temporaryError,
      );
    }
  }

  /// User retry from gate UI.
  Future<void> retry() => resume(force: true);

  /// Pairing success: secure write + authenticated memory (security.md §4).
  Future<void> applyPairedSession({
    required String memberId,
    required String sessionToken,
    required DateTime anniversaryDate,
    required List<Member> members,
  }) async {
    await _repo.writeLocal(memberId: memberId, sessionToken: sessionToken);
    if (!_alive) return;

    Member self = Member(id: memberId, nickname: '');
    for (final m in members) {
      if (m.id == memberId) {
        self = m;
        break;
      }
    }

    final snapshot = SessionSnapshot(
      member: self,
      members: members,
      anniversaryDate: anniversaryDate,
      fetchedAt: DateTime.now(),
    );
    _apply(
      SessionControllerState.authenticated(snapshot),
      SessionAuthStatus.authenticated,
    );
  }

  /// Clears secure keys + memory (Settings / after UNAUTHORIZED path).
  Future<void> clearLocal() async {
    await _repo.clearLocal();
    if (!_alive) return;
    _apply(
      const SessionControllerState.unauthenticated(),
      SessionAuthStatus.unauthenticated,
    );
  }

  bool get _alive {
    try {
      // Touch ref; throws if provider container disposed.
      ref.read(sessionAuthNotifierProvider);
      return true;
    } catch (_) {
      return false;
    }
  }

  void _apply(SessionControllerState next, SessionAuthStatus auth) {
    if (!_alive) return;
    state = next;
    _setAuth(auth);
  }

  void _setAuth(SessionAuthStatus auth) {
    try {
      _auth.setStatus(auth);
    } catch (_) {
      // Container disposed mid-flight.
    }
  }
}

/// Documented session owner (docs/state-management.md, coding-standard.md).
final sessionControllerProvider =
    NotifierProvider<SessionController, SessionControllerState>(
      SessionController.new,
    );

/// Derived member id (docs/state-management.md, coding-standard.md).
final currentMemberIdProvider = Provider<String?>((ref) {
  return ref.watch(sessionControllerProvider).memberId;
});

/// UI / gate phase (maps to [SessionAuthStatus] for redirects).
enum SessionPhase { unknown, unauthenticated, authenticated, temporaryError }

class SessionControllerState {
  const SessionControllerState._({
    required this.status,
    this.snapshot,
    this.failure,
  });

  const SessionControllerState.unknown() : this._(status: SessionPhase.unknown);

  const SessionControllerState.unauthenticated()
    : this._(status: SessionPhase.unauthenticated);

  const SessionControllerState.authenticated(SessionSnapshot snapshot)
    : this._(status: SessionPhase.authenticated, snapshot: snapshot);

  const SessionControllerState.temporaryError(AppFailure failure)
    : this._(status: SessionPhase.temporaryError, failure: failure);

  final SessionPhase status;
  final SessionSnapshot? snapshot;
  final AppFailure? failure;

  String? get memberId => snapshot?.member.id;
}
