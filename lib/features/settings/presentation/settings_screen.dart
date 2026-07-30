import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/config/app_config.dart';
import '../../../core/connectivity/connectivity_providers.dart';
import '../../../core/error/app_failure.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/offline_notice.dart';
import '../../../shared/widgets/page_header.dart';
import '../../../shared/widgets/scrapbook_card.dart';
import '../../session/presentation/session_controller.dart';
import 'settings_providers.dart';
import 'widgets/confirm_clear_session_dialog.dart';
import 'widgets/settings_diagnostics_result.dart';
import 'widgets/settings_menu_card.dart';
import 'widgets/settings_profile_card.dart';

/// Settings v1 tools (docs/screen-specs/settings.md, implementation-order §2.5).
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  static const _title = 'Settings';
  static const _cekKoneksi = 'Cek koneksi';
  static const _cekSession = 'Cek session';
  static const _clearLocal = 'Hapus session lokal';
  static const _offlineBlocked = 'Butuh internet buat mengubah data.';
  static const _dangerZone = 'Zona sensitif';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionControllerProvider);
    final diagnostics = ref.watch(settingsDiagnosticsProvider);
    final online = ref.watch(isOnlineProvider);

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.x4,
        AppSpacing.x4,
        AppSpacing.x4,
        AppSpacing.contentClearance,
      ),
      children: [
        if (!online) const OfflineNotice(),
        const PageHeader(title: _title),
        SettingsProfileCard(snapshot: session.snapshot),
        const SizedBox(height: AppSpacing.x4),
        SettingsMenuCard(
          label: _cekKoneksi,
          tone: ScrapTone.mint,
          enabled: online && !diagnostics.isBusy,
          isLoading: diagnostics.isCheckingConnection,
          onTap: () => _onCheckConnection(context, ref),
        ),
        const SizedBox(height: AppSpacing.x3),
        SettingsMenuCard(
          label: _cekSession,
          tone: ScrapTone.blue,
          enabled: online && !diagnostics.isBusy,
          isLoading: diagnostics.isCheckingSession,
          onTap: () => _onCheckSession(context, ref),
        ),
        const SizedBox(height: AppSpacing.x3),
        _ApiBaseLabel(url: AppConfig.apiBaseUrl),
        const SizedBox(height: AppSpacing.x5),
        Text(
          _dangerZone,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: AppColors.mutedForeground,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: AppSpacing.x3),
        ScrapbookCard(
          tone: ScrapTone.pink,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppButton(
                label: _clearLocal,
                variant: AppButtonVariant.destructive,
                expanded: true,
                isLoading: diagnostics.isClearingSession,
                onPressed: diagnostics.isBusy
                    ? null
                    : () => _onClearLocal(context, ref),
                semanticLabel: 'Hapus session lokal, aksi kritis',
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.x4),
        SettingsDiagnosticsResult(state: diagnostics),
      ],
    );
  }

  Future<void> _onCheckConnection(BuildContext context, WidgetRef ref) async {
    try {
      await ref.read(settingsDiagnosticsProvider.notifier).checkConnection();
    } on AppFailure catch (e) {
      if (!context.mounted) return;
      if (e.code == 'OFFLINE_MUTATION_BLOCKED' || e.code == 'NETWORK_OFFLINE') {
        _toast(context, _offlineBlocked);
      }
    } catch (_) {}
  }

  Future<void> _onCheckSession(BuildContext context, WidgetRef ref) async {
    try {
      await ref.read(settingsDiagnosticsProvider.notifier).checkSession();
      if (!context.mounted) return;
      final phase = ref.read(sessionControllerProvider);
      if (phase.status == SessionPhase.unauthenticated) {
        final clear = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            backgroundColor: AppColors.card,
            title: Text(
              'Session tidak valid',
              style: Theme.of(ctx).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            content: const Text(
              'Hapus session lokal dan pairing ulang?',
            ),
            actions: [
              AppButton(
                label: 'Batal',
                variant: AppButtonVariant.ghost,
                onPressed: () => Navigator.of(ctx).pop(false),
              ),
              AppButton(
                label: 'Hapus',
                variant: AppButtonVariant.destructive,
                onPressed: () => Navigator.of(ctx).pop(true),
              ),
            ],
          ),
        );
        if (clear == true && context.mounted) {
          await ref
              .read(settingsDiagnosticsProvider.notifier)
              .clearLocalSession();
          if (context.mounted) {
            context.go(AppRoutes.pairing);
          }
        }
      }
    } on AppFailure catch (e) {
      if (!context.mounted) return;
      if (e.code == 'OFFLINE_MUTATION_BLOCKED' || e.code == 'NETWORK_OFFLINE') {
        _toast(context, _offlineBlocked);
      }
    } catch (_) {}
  }

  Future<void> _onClearLocal(BuildContext context, WidgetRef ref) async {
    final confirmed = await showConfirmClearSessionDialog(context);
    if (!confirmed || !context.mounted) return;
    try {
      await ref.read(settingsDiagnosticsProvider.notifier).clearLocalSession();
      if (context.mounted) {
        context.go(AppRoutes.pairing);
      }
    } catch (_) {
      if (context.mounted) {
        _toast(context, 'Ada yang error nih');
      }
    }
  }

  void _toast(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

/// Truncated non-secret API base label (screen-specs/settings.md).
class _ApiBaseLabel extends StatelessWidget {
  const _ApiBaseLabel({required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    final display = _truncate(url);
    return Text(
      'API: $display',
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
        color: AppColors.mutedForeground,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  static String _truncate(String raw) {
    if (raw.isEmpty) return '(belum diset)';
    if (raw.length <= 48) return raw;
    return '${raw.substring(0, 20)}…${raw.substring(raw.length - 16)}';
  }
}
