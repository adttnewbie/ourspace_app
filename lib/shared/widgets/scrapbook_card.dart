import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radii.dart';
import '../../core/theme/app_shadows.dart';
import '../../core/theme/app_spacing.dart';

/// Primary paper surface (design.md §12 ScrapbookCard).
class ScrapbookCard extends StatefulWidget {
  const ScrapbookCard({
    super.key,
    required this.child,
    this.tone = ScrapTone.white,
    this.tape = false,
    this.onTap,
    this.padding,
  });

  final Widget child;
  final ScrapTone tone;
  final bool tape;
  final VoidCallback? onTap;

  /// Defaults to 16 / 20 (design.md card default padding).
  final EdgeInsetsGeometry? padding;

  @override
  State<ScrapbookCard> createState() => _ScrapbookCardState();
}

class _ScrapbookCardState extends State<ScrapbookCard> {
  bool _pressed = false;

  EdgeInsetsGeometry get _padding =>
      widget.padding ??
      const EdgeInsets.symmetric(
        horizontal: AppSpacing.x4,
        vertical: AppSpacing.x5,
      );

  @override
  Widget build(BuildContext context) {
    final tappable = widget.onTap != null;
    final shadows = tappable && _pressed
        ? AppShadows.cardPress
        : AppShadows.softCard;

    final card = AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      transform: tappable && _pressed
          ? Matrix4.translationValues(0, 1, 0)
          : Matrix4.identity(),
      decoration: BoxDecoration(
        color: widget.tone.backgroundColor(),
        borderRadius: AppRadii.scrapbookCardBorder,
        border: Border.all(color: AppColors.border, width: 1),
        boxShadow: shadows,
      ),
      child: ClipRRect(
        borderRadius: AppRadii.scrapbookCardBorder,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: _DashedInsetPainter(
                  color: AppColors.border.withValues(alpha: 0.55),
                  radius: AppRadii.scrapbookCard - 6,
                  inset: AppSpacing.x2,
                ),
              ),
            ),
            if (widget.tape)
              const Positioned(
                top: AppSpacing.x2,
                left: 0,
                right: 0,
                child: ExcludeSemantics(child: Center(child: _TapeStrip())),
              ),
            Padding(padding: _padding, child: widget.child),
          ],
        ),
      ),
    );

    if (!tappable) return card;

    return Semantics(
      button: true,
      child: GestureDetector(
        onTap: widget.onTap,
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        child: card,
      ),
    );
  }
}

class _TapeStrip extends StatelessWidget {
  const _TapeStrip();

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: -6 * math.pi / 180,
      child: Container(
        width: 72,
        height: 14,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.70),
          borderRadius: BorderRadius.circular(AppRadii.sm),
          boxShadow: AppShadows.tape,
        ),
      ),
    );
  }
}

class _DashedInsetPainter extends CustomPainter {
  _DashedInsetPainter({
    required this.color,
    required this.radius,
    required this.inset,
  });

  final Color color;
  final double radius;
  final double inset;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(
      inset,
      inset,
      size.width - inset * 2,
      size.height - inset * 2,
    );
    if (rect.width <= 0 || rect.height <= 0) return;

    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(radius));
    final path = Path()..addRRect(rrect);
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      const dash = 5.0;
      const gap = 4.0;
      while (distance < metric.length) {
        final next = math.min(distance + dash, metric.length);
        canvas.drawPath(metric.extractPath(distance, next), paint);
        distance = next + gap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedInsetPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.radius != radius ||
        oldDelegate.inset != inset;
  }
}
