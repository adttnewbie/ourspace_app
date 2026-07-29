import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';

/// Authenticated chrome shell (docs/routing.md §3).
///
/// Step 1.8: max-width column + basic bottom nav. Final polish is step 2.7.
class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  static const _labels = <String>['Home', 'Notes', 'Gallery', 'Dates', 'More'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: AppSpacing.phoneMaxWidth,
            ),
            child: navigationShell,
          ),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
        destinations: [
          for (var i = 0; i < _labels.length; i++)
            NavigationDestination(icon: Icon(_iconFor(i)), label: _labels[i]),
        ],
      ),
    );
  }

  static IconData _iconFor(int index) {
    switch (index) {
      case 0:
        return Icons.home_outlined;
      case 1:
        return Icons.sticky_note_2_outlined;
      case 2:
        return Icons.photo_outlined;
      case 3:
        return Icons.calendar_today_outlined;
      default:
        return Icons.more_horiz;
    }
  }
}
