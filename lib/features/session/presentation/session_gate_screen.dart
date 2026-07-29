import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/loading_skeleton.dart';
import '../../../shared/widgets/scrapbook_card.dart';
import 'session_controller.dart';

/// Holding / retry UI while SessionGate runs (docs/routing.md §6).
///
/// Copy: `error.timeout`, `error.generic_body`, `shared.retry` (copy-catalog.md).
class SessionGateScreen extends ConsumerWidget {
  const SessionGateScreen({super.key});

  static const _retryLabel = 'Coba lagi';
  static const _timeoutBody = 'Koneksi timeout. Coba lagi.';
  static const _genericBody = 'Coba lagi sebentar ya.';
  static const _checkingLabel = 'Memeriksa sesi…';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionControllerProvider);
    final isRetrying = session.status == SessionPhase.unknown;
    final isError = session.status == SessionPhase.temporaryError;

    final message = switch (session.failure?.code) {
      'NETWORK_TIMEOUT' => _timeoutBody,
      'NETWORK_OFFLINE' || 'NETWORK_UNKNOWN' => _timeoutBody,
      _ => _genericBody,
    };

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.x6),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: ScrapbookCard(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (isRetrying || !isError) ...[
                      Text(
                        _checkingLabel,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(color: AppColors.foreground),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppSpacing.x4),
                      const SkeletonBox(height: 12, width: double.infinity),
                      const SizedBox(height: AppSpacing.x2),
                      const SkeletonBox(height: 12, width: 180),
                    ],
                    if (isError) ...[
                      Text(
                        message,
                        style: Theme.of(context).textTheme.bodyMedium
                            ?.copyWith(color: AppColors.foreground),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppSpacing.x5),
                      AppButton(
                        label: _retryLabel,
                        onPressed: isRetrying
                            ? null
                            : () {
                                ref
                                    .read(sessionControllerProvider.notifier)
                                    .retry();
                              },
                        isLoading: isRetrying,
                        expanded: true,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
