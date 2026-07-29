import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_shadows.dart';

/// Circular 3s hold control (screen-specs/pairing.md, design.md ~208).
class HoldPairingButton extends StatefulWidget {
  const HoldPairingButton({
    super.key,
    required this.enabled,
    required this.busy,
    required this.onHoldStart,
    required this.onHoldCancel,
    required this.onHoldComplete,
    required this.onProgress,
    this.holdDuration = const Duration(seconds: 3),
    this.size = 208,
  });

  final bool enabled;
  final bool busy;
  final VoidCallback onHoldStart;
  final VoidCallback onHoldCancel;
  final VoidCallback onHoldComplete;
  final ValueChanged<double> onProgress;
  final Duration holdDuration;
  final double size;

  @override
  State<HoldPairingButton> createState() => _HoldPairingButtonState();
}

class _HoldPairingButtonState extends State<HoldPairingButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _holding = false;
  bool _completed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.holdDuration,
    );
    _controller.addListener(_onTick);
    _controller.addStatusListener(_onStatus);
  }

  @override
  void didUpdateWidget(HoldPairingButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.holdDuration != widget.holdDuration) {
      _controller.duration = widget.holdDuration;
    }
    if (!widget.enabled && _holding) {
      _cancel();
    }
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_onTick)
      ..removeStatusListener(_onStatus)
      ..dispose();
    super.dispose();
  }

  void _onTick() {
    widget.onProgress(_controller.value);
  }

  void _onStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed && _holding && !_completed) {
      _completed = true;
      _holding = false;
      widget.onHoldComplete();
    }
  }

  void _start() {
    if (!widget.enabled || widget.busy || _holding) return;
    _completed = false;
    _holding = true;
    widget.onHoldStart();
    _controller.forward(from: 0);
  }

  void _cancelIfIncomplete() {
    if (!_holding || _completed) return;
    _cancel();
  }

  void _cancel() {
    _holding = false;
    _completed = false;
    _controller.stop();
    _controller.value = 0;
    widget.onProgress(0);
    widget.onHoldCancel();
  }

  @override
  Widget build(BuildContext context) {
    final interactive = widget.enabled && !widget.busy;

    return Semantics(
      button: true,
      enabled: interactive,
      label: 'Tahan tiga detik untuk pairing',
      value: _holding ? '${(_controller.value * 100).round()} persen' : null,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: interactive ? (_) => _start() : null,
        onTapUp: (_) => _cancelIfIncomplete(),
        onTapCancel: _cancelIfIncomplete,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final progress = _controller.value;
            final scale = _holding ? 0.98 : 1.0;
            return Transform.scale(
              scale: scale,
              child: SizedBox(
                width: widget.size,
                height: widget.size,
                child: CustomPaint(
                  painter: _HoldRingPainter(
                    progress: progress,
                    enabled: interactive || _holding || widget.busy,
                  ),
                  child: Center(
                    child: widget.busy
                        ? const SizedBox(
                            width: 36,
                            height: 36,
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              color: AppColors.primaryForeground,
                            ),
                          )
                        : Icon(
                            // design.md HeartHandshake; Material fallback
                            // (lucide_icons incompatible with final IconData).
                            Icons.favorite,
                            size: 56,
                            color: interactive || _holding
                                ? AppColors.primaryForeground
                                : AppColors.mutedForeground,
                          ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _HoldRingPainter extends CustomPainter {
  _HoldRingPainter({required this.progress, required this.enabled});

  final double progress;
  final bool enabled;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final fill = Paint()
      ..color = enabled ? AppColors.primary : AppColors.muted
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, fill);

    final border = Paint()
      ..color = AppColors.border
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(center, radius - 1, border);

    if (progress > 0) {
      final track = Paint()
        ..color = AppColors.primaryForeground.withValues(alpha: 0.25)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6
        ..strokeCap = StrokeCap.round;
      canvas.drawCircle(center, radius - 10, track);

      final arc = Paint()
        ..color = AppColors.primaryForeground
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6
        ..strokeCap = StrokeCap.round;
      final rect = Rect.fromCircle(center: center, radius: radius - 10);
      canvas.drawArc(rect, -1.57079632679, progress * 6.28318530718, false, arc);
    }
  }

  @override
  bool shouldRepaint(covariant _HoldRingPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.enabled != enabled;
  }
}

/// Glow wrapper matching design.md hold shadow.
class HoldPairingButtonShell extends StatelessWidget {
  const HoldPairingButtonShell({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: AppShadows.hold,
      ),
      child: child,
    );
  }
}
