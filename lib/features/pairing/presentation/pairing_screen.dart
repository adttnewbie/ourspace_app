import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/connectivity/connectivity_providers.dart';
import '../../../core/error/app_failure.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_text_field.dart';
import 'pairing_controller.dart';
import 'pairing_state.dart';
import 'widgets/hold_pairing_button.dart';

/// Pairing ritual screen (docs/screen-specs/pairing.md, copy-catalog.md).
class PairingScreen extends ConsumerWidget {
  const PairingScreen({super.key});

  // copy-catalog.md Pairing
  static const _title = 'OurSpace';
  static const _subtitle = 'Ruang berdua, mulai bareng.';
  static const _nicknameLabel = 'Nama / nickname kamu';
  static const _nicknameHint = 'Misal: Ae';
  static const _holdIdle = 'Tahan bareng-bareng.';
  static const _holdHolding = 'Sedikit lagi…';
  static const _waiting = 'Nunggu pasangan kamu...';
  static const _paired = 'Berhasil! Selamat ya.';
  static const _expired = 'Belum barengan, coba sekali lagi.';
  static const _retry = 'Coba lagi';
  static const _offlineBlocked = 'Butuh internet buat pairing dulu ya.';
  static const _errorTimeout = 'Koneksi timeout. Coba lagi.';
  static const _errorServer = 'Server lagi bermasalah.';
  static const _errorBadRequest = 'Isian belum valid.';
  static const _errorGeneric = 'Ada yang error nih';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(pairingControllerProvider);
    final online = ref.watch(isOnlineProvider);
    final controller = ref.read(pairingControllerProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.x6),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: AppSpacing.standaloneCardMaxWidth,
              ),
              child: PairingCard(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      _title,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(
                            color: AppColors.foreground,
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                    const SizedBox(height: AppSpacing.x2),
                    Text(
                      _subtitle,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.mutedForeground,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x6),
                    NicknameField(
                      enabled:
                          state.phase == PairingPhase.idle ||
                          state.phase == PairingPhase.error ||
                          state.phase == PairingPhase.expired,
                      onChanged: controller.setNickname,
                    ),
                    const SizedBox(height: AppSpacing.x6),
                    Center(
                      child: HoldPairingButtonShell(
                        child: HoldPairingButton(
                          enabled:
                              online &&
                              state.canStartHold &&
                              state.phase != PairingPhase.expired,
                          busy:
                              state.phase == PairingPhase.submitting ||
                              state.phase == PairingPhase.waiting,
                          onHoldStart: controller.beginHold,
                          onHoldCancel: controller.cancelHold,
                          onHoldComplete: () {
                            controller.completeHold();
                          },
                          onProgress: controller.updateHoldProgress,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x5),
                    PairingStatusText(
                      text: _statusText(state, online: online),
                      phase: state.phase,
                    ),
                    if (state.phase == PairingPhase.waiting) ...[
                      const SizedBox(height: AppSpacing.x2),
                      PairingCountdown(seconds: state.secondsRemaining ?? 0),
                    ],
                    if (state.phase == PairingPhase.expired ||
                        state.phase == PairingPhase.error) ...[
                      const SizedBox(height: AppSpacing.x5),
                      AppButton(
                        label: _retry,
                        onPressed: controller.retry,
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

  static String _statusText(PairingState state, {required bool online}) {
    if (!online &&
        (state.phase == PairingPhase.idle ||
            state.phase == PairingPhase.error ||
            state.phase == PairingPhase.holding)) {
      return _offlineBlocked;
    }
    switch (state.phase) {
      case PairingPhase.idle:
        return _holdIdle;
      case PairingPhase.holding:
        return _holdHolding;
      case PairingPhase.submitting:
        return _holdHolding;
      case PairingPhase.waiting:
        return _waiting;
      case PairingPhase.paired:
        return _paired;
      case PairingPhase.expired:
        return _expired;
      case PairingPhase.error:
        return _errorCopy(state.failure);
    }
  }

  static String _errorCopy(AppFailure? failure) {
    switch (failure?.code) {
      case 'OFFLINE_MUTATION_BLOCKED':
      case 'NETWORK_OFFLINE':
        return _offlineBlocked;
      case 'NETWORK_TIMEOUT':
      case 'NETWORK_UNKNOWN':
        return _errorTimeout;
      case 'BAD_REQUEST':
      case 'VALIDATION':
        return _errorBadRequest;
      case 'INTERNAL_ERROR':
        return _errorServer;
      case 'PAIRING_EXPIRED':
        return _expired;
      default:
        return _errorGeneric;
    }
  }
}

/// Lifted pairing card (screen-specs + design.md radius 32 / lifted shadow).
class PairingCard extends StatelessWidget {
  const PairingCard({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppRadii.dialog),
        border: Border.all(color: AppColors.border),
        boxShadow: AppShadows.lifted,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x5,
        vertical: AppSpacing.x6,
      ),
      child: child,
    );
  }
}

class NicknameField extends StatefulWidget {
  const NicknameField({
    super.key,
    required this.enabled,
    required this.onChanged,
    this.initialValue = '',
  });

  final bool enabled;
  final ValueChanged<String> onChanged;
  final String initialValue;

  @override
  State<NicknameField> createState() => _NicknameFieldState();
}

class _NicknameFieldState extends State<NicknameField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void didUpdateWidget(covariant NicknameField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue &&
        widget.initialValue != _controller.text) {
      _controller.text = widget.initialValue;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: _controller,
      enabled: widget.enabled,
      label: PairingScreen._nicknameLabel,
      hintText: PairingScreen._nicknameHint,
      maxLength: PairingState.maxNicknameLength,
      textCapitalization: TextCapitalization.words,
      textInputAction: TextInputAction.done,
      onChanged: widget.onChanged,
    );
  }
}

class PairingStatusText extends StatelessWidget {
  const PairingStatusText({
    super.key,
    required this.text,
    required this.phase,
  });

  final String text;
  final PairingPhase phase;

  @override
  Widget build(BuildContext context) {
    final announce =
        phase == PairingPhase.waiting ||
        phase == PairingPhase.expired ||
        phase == PairingPhase.paired ||
        phase == PairingPhase.error;

    return Semantics(
      liveRegion: announce,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: AppColors.foreground,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class PairingCountdown extends StatelessWidget {
  const PairingCountdown({super.key, required this.seconds});

  final int seconds;

  @override
  Widget build(BuildContext context) {
    final label = 'Sisa $seconds dtk';
    return Semantics(
      liveRegion: true,
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: AppColors.mutedForeground,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
