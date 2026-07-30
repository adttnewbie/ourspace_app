import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/connectivity/connectivity_providers.dart';
import '../../../core/error/app_failure.dart';
import '../../../core/network/network_providers.dart';
import '../../home/presentation/home_providers.dart';
import '../../notes/presentation/notes_providers.dart';
import '../../session/presentation/session_controller.dart';
import '../data/settings_repository_impl.dart';
import '../domain/settings_repository.dart';
import 'settings_diagnostics_state.dart';

/// Documented repository provider (docs/state-management.md §2).
final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepositoryImpl(apiClient: ref.watch(apiClientProvider));
});

/// Ephemeral diagnostics UI state (docs/state-management.md).
final settingsDiagnosticsProvider =
    NotifierProvider<SettingsDiagnosticsNotifier, SettingsDiagnosticsState>(
      SettingsDiagnosticsNotifier.new,
    );

/// Owns connection/session checks + local clear orchestration (screen-specs/settings.md).
class SettingsDiagnosticsNotifier extends Notifier<SettingsDiagnosticsState> {
  @override
  SettingsDiagnosticsState build() => const SettingsDiagnosticsState();

  /// `health.check` (screen-specs/settings.md Cek koneksi).
  Future<void> checkConnection() async {
    if (state.isBusy) return;
    ref.read(offlineGuardProvider).ensureOnline();

    state = state.copyWith(isCheckingConnection: true);
    try {
      await ref.read(settingsRepositoryProvider).checkHealth();
      state = state.copyWith(
        isCheckingConnection: false,
        lastOk: true,
        lastMessage: 'Backend tersambung.',
      );
    } on AppFailure catch (e) {
      state = state.copyWith(
        isCheckingConnection: false,
        lastOk: false,
        lastMessage: _mapFailure(e),
      );
      rethrow;
    } catch (_) {
      state = state.copyWith(
        isCheckingConnection: false,
        lastOk: false,
        lastMessage: 'Ada yang error nih',
      );
      rethrow;
    }
  }

  /// Force `session.resume` (state-management.md: bypass resume TTL).
  Future<void> checkSession() async {
    if (state.isBusy) return;
    ref.read(offlineGuardProvider).ensureOnline();

    state = state.copyWith(isCheckingSession: true);
    try {
      await ref.read(sessionControllerProvider.notifier).resume(force: true);
      final phase = ref.read(sessionControllerProvider);
      if (phase.status == SessionPhase.authenticated) {
        final nick = phase.snapshot?.member.nickname.trim();
        final label = (nick == null || nick.isEmpty) ? 'OK' : nick;
        state = state.copyWith(
          isCheckingSession: false,
          lastOk: true,
          lastMessage: 'Session valid ($label).',
        );
      } else if (phase.status == SessionPhase.unauthenticated) {
        state = state.copyWith(
          isCheckingSession: false,
          lastOk: false,
          lastMessage: 'Session tidak valid. Pairing ulang ya.',
        );
      } else if (phase.status == SessionPhase.temporaryError) {
        final code = phase.failure?.code;
        state = state.copyWith(
          isCheckingSession: false,
          lastOk: false,
          lastMessage: code == 'UNAUTHORIZED'
              ? 'Session tidak valid. Pairing ulang ya.'
              : _mapFailure(phase.failure!),
        );
      } else {
        state = state.copyWith(
          isCheckingSession: false,
          lastOk: false,
          lastMessage: 'Session belum siap.',
        );
      }
    } on AppFailure catch (e) {
      state = state.copyWith(
        isCheckingSession: false,
        lastOk: false,
        lastMessage: _mapFailure(e),
      );
      rethrow;
    } catch (_) {
      state = state.copyWith(
        isCheckingSession: false,
        lastOk: false,
        lastMessage: 'Ada yang error nih',
      );
      rethrow;
    }
  }

  /// Local clear: secure storage + list caches + providers (security.md §4).
  ///
  /// Does not call backend. Router redirects to `/pairing` via auth status.
  Future<void> clearLocalSession() async {
    if (state.isBusy) return;
    state = state.copyWith(isClearingSession: true);
    try {
      try {
        await ref.read(homeRepositoryProvider).clearCache();
      } catch (_) {}
      try {
        await ref.read(notesRepositoryProvider).clearCache();
      } catch (_) {}

      await ref.read(sessionControllerProvider.notifier).clearLocal();

      ref.invalidate(homeProvider);
      ref.invalidate(notesListProvider);

      state = state.copyWith(
        isClearingSession: false,
        clearMessage: true,
      );
    } catch (_) {
      state = state.copyWith(isClearingSession: false);
      rethrow;
    }
  }

  String _mapFailure(AppFailure e) {
    return switch (e.code) {
      'OFFLINE_MUTATION_BLOCKED' || 'NETWORK_OFFLINE' =>
        'Butuh internet buat mengubah data.',
      'NETWORK_TIMEOUT' => 'Koneksi timeout. Coba lagi.',
      'UNAUTHORIZED' => 'Session tidak valid. Pairing ulang ya.',
      _ => e.message?.trim().isNotEmpty == true
          ? e.message!
          : 'Ada yang error nih',
    };
  }
}
