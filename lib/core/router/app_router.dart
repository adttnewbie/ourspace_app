import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/home/presentation/home_screen.dart';
import '../../features/notes/presentation/notes_screen.dart';
import '../../features/pairing/presentation/pairing_screen.dart';
import '../../features/session/presentation/session_gate_screen.dart';
import '../../features/settings/presentation/settings_placeholder_screen.dart';
import '../../shared/widgets/app_shell.dart';
import '../../shared/widgets/route_placeholder_screen.dart';
import 'app_routes.dart';
import 'session_auth.dart';

/// Auth boundary redirects (docs/routing.md §6–7). Pure for unit tests.
String? resolveAuthRedirect({
  required SessionAuthStatus status,
  required String matchedLocation,
}) {
  final loc = matchedLocation;
  final isPairing = loc == AppRoutes.pairing;
  final isPublic =
      loc == AppRoutes.pairing ||
      loc == AppRoutes.offline ||
      loc == AppRoutes.error;

  if (status == SessionAuthStatus.unknown) {
    if (!isPublic) return AppRoutes.pairing;
    return null;
  }

  if (status == SessionAuthStatus.temporaryError) {
    if (!isPublic) return AppRoutes.pairing;
    return null;
  }

  if (status == SessionAuthStatus.unauthenticated) {
    if (isPublic) return null;
    return AppRoutes.pairing;
  }

  if (isPairing) return AppRoutes.home;
  return null;
}

/// Pairing path: gate while checking / temporaryError; PairingScreen otherwise.
class _PairingRouteBody extends ConsumerWidget {
  const _PairingRouteBody();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(sessionAuthNotifierProvider).status;
    if (auth == SessionAuthStatus.unknown ||
        auth == SessionAuthStatus.temporaryError) {
      return const SessionGateScreen();
    }
    return const PairingScreen();
  }
}

/// Builds [GoRouter] with shell + redirects (docs/routing.md).
GoRouter createAppRouter({
  required SessionAuthNotifier sessionAuth,
  String? initialLocation,
}) {
  return GoRouter(
    initialLocation: initialLocation ?? AppRoutes.home,
    refreshListenable: sessionAuth,
    redirect: (context, state) {
      return resolveAuthRedirect(
        status: sessionAuth.status,
        matchedLocation: state.matchedLocation,
      );
    },
    routes: [
      GoRoute(
        path: AppRoutes.pairing,
        name: 'pairing',
        builder: (context, state) => const _PairingRouteBody(),
      ),
      GoRoute(
        path: AppRoutes.offline,
        name: 'offline',
        builder: (context, state) => const RoutePlaceholderScreen(
          title: 'Offline',
          subtitle: 'Placeholder bantuan offline.',
        ),
      ),
      GoRoute(
        path: AppRoutes.error,
        name: 'error',
        builder: (context, state) => const RoutePlaceholderScreen(
          title: 'Error',
          subtitle: 'Placeholder fatal error.',
        ),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AppShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                name: 'home',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.notes,
                name: 'notes',
                builder: (context, state) => const NotesScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.gallery,
                name: 'gallery',
                builder: (context, state) => const RoutePlaceholderScreen(
                  title: 'Gallery',
                  subtitle: 'Segera hadir',
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.dates,
                name: 'dates',
                builder: (context, state) => const RoutePlaceholderScreen(
                  title: 'Dates',
                  subtitle: 'Segera hadir',
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.settings,
                name: 'settings',
                builder: (context, state) => const SettingsPlaceholderScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => const RoutePlaceholderScreen(
      title: 'Halaman tidak ada',
      subtitle: 'Coba kembali ke Home atau Pairing.',
    ),
  );
}
