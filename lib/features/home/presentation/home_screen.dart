import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/connectivity/connectivity_providers.dart';
import '../../../core/error/app_failure.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/widgets/loading_skeleton.dart';
import '../../../shared/widgets/offline_notice.dart';
import '../domain/home_snapshot.dart';
import 'home_providers.dart';
import 'widgets/greeting_card.dart';
import 'widgets/home_error_card.dart';
import 'widgets/home_status_pill.dart';
import 'widgets/quick_add_sticky.dart';
import 'widgets/summary_card.dart';
import 'widgets/today_notes_section.dart';

/// Home screen (docs/screen-specs/home.md, implementation-order §2.3).
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  static const _refreshing = 'Lagi nyegerin data...';
  static const _summaryNotes = 'Notes';
  static const _summaryGallery = 'Gallery';
  static const _summaryDates = 'Dates';
  static const _comingSoon = 'Segera hadir';
  static const _softWarning = 'Koneksi timeout. Coba lagi.';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncHome = ref.watch(homeProvider);
    final online = ref.watch(isOnlineProvider);

    return asyncHome.when(
      loading: () => const _HomeScroll(child: HomeSkeleton()),
      error: (error, _) {
        final offlineNoCache =
            !online &&
            (error is NetworkFailure && error.code == 'NETWORK_OFFLINE');
        if (offlineNoCache) {
          return const _HomeScroll(child: OfflineEmptyState());
        }
        return _HomeScroll(
          child: HomeErrorCard(
            onRetry: () => ref.read(homeProvider.notifier).refresh(),
          ),
        );
      },
      data: (view) => _HomeBody(view: view, online: online),
    );
  }
}

class _HomeBody extends ConsumerWidget {
  const _HomeBody({required this.view, required this.online});

  final HomeViewState view;
  final bool online;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = view.snapshot;
    final showOfflineBanner = !online;
    final showRefreshing = view.isRefreshing;
    final showSoftWarning = view.softWarning && !view.isRefreshing;

    return RefreshIndicator(
      onRefresh: () => ref.read(homeProvider.notifier).refresh(),
      child: _HomeScroll(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (showOfflineBanner) const OfflineNotice(),
            if (showRefreshing)
              const HomeStatusPill(label: HomeScreen._refreshing),
            if (showSoftWarning)
              const HomeStatusPill(label: HomeScreen._softWarning),
            GreetingCard(snapshot: snapshot),
            const SizedBox(height: AppSpacing.x4),
            const QuickAddSticky(),
            const SizedBox(height: AppSpacing.x4),
            SummaryCard(
              title: HomeScreen._summaryNotes,
              description: '${snapshot.stickyNotesCount}',
              icon: Icons.sticky_note_2_outlined,
              tone: ScrapTone.mint,
              onTap: () => context.go(AppRoutes.notes),
            ),
            const SizedBox(height: AppSpacing.x3),
            SummaryCard(
              title: HomeScreen._summaryGallery,
              description: HomeScreen._comingSoon,
              icon: Icons.photo_outlined,
              tone: ScrapTone.yellow,
              onTap: () => context.go(AppRoutes.gallery),
            ),
            const SizedBox(height: AppSpacing.x3),
            SummaryCard(
              title: HomeScreen._summaryDates,
              description: HomeScreen._comingSoon,
              icon: Icons.calendar_today_outlined,
              tone: ScrapTone.blue,
              onTap: () => context.go(AppRoutes.dates),
            ),
            if (snapshot.todayStickyNotes.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.x5),
              TodayNotesSection(notes: snapshot.todayStickyNotes),
            ],
            const SizedBox(height: AppSpacing.contentClearance),
          ],
        ),
      ),
    );
  }
}

class _HomeScroll extends StatelessWidget {
  const _HomeScroll({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.x4,
            AppSpacing.x4,
            AppSpacing.x4,
            AppSpacing.x4,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: child,
          ),
        );
      },
    );
  }
}
