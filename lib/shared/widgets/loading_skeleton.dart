import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radii.dart';
import '../../core/theme/app_spacing.dart';
import 'scrapbook_card.dart';

/// Pulse block primitive (design.md §12 Loading skeletons).
class SkeletonBox extends StatefulWidget {
  const SkeletonBox({
    super.key,
    this.width,
    this.height = 16,
    this.borderRadius,
  });

  final double? width;
  final double height;
  final BorderRadius? borderRadius;

  @override
  State<SkeletonBox> createState() => _SkeletonBoxState();
}

class _SkeletonBoxState extends State<SkeletonBox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _opacity = Tween<double>(
      begin: 0.45,
      end: 0.9,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final reduce = MediaQuery.disableAnimationsOf(context);
    if (reduce) {
      _controller.stop();
      _controller.value = 0.7;
    } else if (!_controller.isAnimating) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: FadeTransition(
        opacity: _opacity,
        child: Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: AppColors.card.withValues(alpha: 0.65),
            borderRadius:
                widget.borderRadius ?? BorderRadius.circular(AppRadii.md),
            border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
          ),
        ),
      ),
    );
  }
}

class SkeletonLine extends StatelessWidget {
  const SkeletonLine({super.key, this.width, this.height = 12});

  final double? width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SkeletonBox(width: width, height: height);
  }
}

/// Layout-matched loading chrome for home (v1).
class HomeSkeleton extends StatelessWidget {
  const HomeSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Memuat',
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ScrapbookCard(
            tone: ScrapTone.pink,
            tape: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonLine(width: 120, height: 14),
                SizedBox(height: AppSpacing.x3),
                SkeletonLine(width: 200, height: 28),
                SizedBox(height: AppSpacing.x2),
                SkeletonLine(width: 160, height: 14),
              ],
            ),
          ),
          SizedBox(height: AppSpacing.x4),
          Row(
            children: [
              Expanded(
                child: ScrapbookCard(
                  tone: ScrapTone.mint,
                  padding: EdgeInsets.all(AppSpacing.x4),
                  child: Column(
                    children: [
                      SkeletonBox(height: 40, width: 40),
                      SizedBox(height: AppSpacing.x2),
                      SkeletonLine(height: 12),
                    ],
                  ),
                ),
              ),
              SizedBox(width: AppSpacing.x3),
              Expanded(
                child: ScrapbookCard(
                  tone: ScrapTone.yellow,
                  padding: EdgeInsets.all(AppSpacing.x4),
                  child: Column(
                    children: [
                      SkeletonBox(height: 40, width: 40),
                      SizedBox(height: AppSpacing.x2),
                      SkeletonLine(height: 12),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Layout-matched loading chrome for notes (v1).
class NotesSkeleton extends StatelessWidget {
  const NotesSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Memuat',
      child: Column(
        children: List.generate(3, (index) {
          final tones = [ScrapTone.yellow, ScrapTone.pink, ScrapTone.mint];
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.x3),
            child: ScrapbookCard(
              tone: tones[index % tones.length],
              tape: index == 0,
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SkeletonLine(width: 80, height: 12),
                  SizedBox(height: AppSpacing.x3),
                  SkeletonLine(height: 14),
                  SizedBox(height: AppSpacing.x2),
                  SkeletonLine(width: 180, height: 14),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

/// Layout-matched loading chrome for settings (v1).
class SettingsSkeleton extends StatelessWidget {
  const SettingsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Memuat',
      child: Column(
        children: [
          ScrapbookCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonLine(width: 100, height: 14),
                SizedBox(height: AppSpacing.x3),
                SkeletonLine(height: 16),
                SizedBox(height: AppSpacing.x2),
                SkeletonLine(width: 140, height: 12),
              ],
            ),
          ),
          SizedBox(height: AppSpacing.x4),
          ScrapbookCard(
            tone: ScrapTone.pink,
            child: Column(
              children: [
                SkeletonLine(height: 40),
                SizedBox(height: AppSpacing.x2),
                SkeletonLine(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Pairing / session status skeleton (v1).
class PairingStatusSkeleton extends StatelessWidget {
  const PairingStatusSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Memuat',
      child: Center(
        child: ScrapbookCard(
          tone: ScrapTone.pink,
          tape: true,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SkeletonBox(
                width: 72,
                height: 72,
                borderRadius: BorderRadius.all(Radius.circular(999)),
              ),
              SizedBox(height: AppSpacing.x4),
              SkeletonLine(width: 160, height: 18),
              SizedBox(height: AppSpacing.x2),
              SkeletonLine(width: 120, height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
