import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ourspace_app/core/router/app_router.dart';
import 'package:ourspace_app/core/router/app_routes.dart';
import 'package:ourspace_app/core/router/session_auth.dart';

void main() {
  group('resolveAuthRedirect (step 2.1)', () {
    test('unauthenticated_shell_toPairing', () {
      expect(
        resolveAuthRedirect(
          status: SessionAuthStatus.unauthenticated,
          matchedLocation: AppRoutes.home,
        ),
        AppRoutes.pairing,
      );
    });

    test('authenticated_pairing_toHome', () {
      expect(
        resolveAuthRedirect(
          status: SessionAuthStatus.authenticated,
          matchedLocation: AppRoutes.pairing,
        ),
        AppRoutes.home,
      );
    });

    test('temporaryError_shell_toPairing_gate', () {
      expect(
        resolveAuthRedirect(
          status: SessionAuthStatus.temporaryError,
          matchedLocation: AppRoutes.home,
        ),
        AppRoutes.pairing,
      );
    });

    test('temporaryError_pairing_stays', () {
      expect(
        resolveAuthRedirect(
          status: SessionAuthStatus.temporaryError,
          matchedLocation: AppRoutes.pairing,
        ),
        isNull,
      );
    });

    test('unknown_shell_toPairing', () {
      expect(
        resolveAuthRedirect(
          status: SessionAuthStatus.unknown,
          matchedLocation: AppRoutes.notes,
        ),
        AppRoutes.pairing,
      );
    });

    test('authenticated_notes_stays', () {
      expect(
        resolveAuthRedirect(
          status: SessionAuthStatus.authenticated,
          matchedLocation: AppRoutes.notes,
        ),
        isNull,
      );
    });
  });

  group('GoRouter redirects (step 1.8 / 2.1)', () {
    testWidgets('unauthenticated_shellPath_redirectsToPairing', (tester) async {
      final auth = SessionAuthNotifier();
      auth.setStatus(SessionAuthStatus.unauthenticated);

      final router = createAppRouter(
        sessionAuth: auth,
        initialLocation: AppRoutes.home,
      );
      addTearDown(router.dispose);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sessionAuthNotifierProvider.overrideWithValue(auth),
          ],
          child: MaterialApp.router(routerConfig: router),
        ),
      );
      await tester.pumpAndSettle();

      expect(router.state.uri.path, AppRoutes.pairing);
      expect(find.text('OurSpace'), findsOneWidget);
    });

    testWidgets('authenticated_pairing_redirectsToHome', (tester) async {
      final auth = SessionAuthNotifier();
      auth.setStatus(SessionAuthStatus.authenticated);

      final router = createAppRouter(
        sessionAuth: auth,
        initialLocation: AppRoutes.pairing,
      );
      addTearDown(router.dispose);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sessionAuthNotifierProvider.overrideWithValue(auth),
          ],
          child: MaterialApp.router(routerConfig: router),
        ),
      );
      await tester.pumpAndSettle();

      expect(router.state.uri.path, AppRoutes.home);
      expect(find.text('Home'), findsWidgets);
    });

    testWidgets('authenticated_notes_staysOnNotes', (tester) async {
      final auth = SessionAuthNotifier();
      auth.setStatus(SessionAuthStatus.authenticated);

      final router = createAppRouter(
        sessionAuth: auth,
        initialLocation: AppRoutes.notes,
      );
      addTearDown(router.dispose);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sessionAuthNotifierProvider.overrideWithValue(auth),
          ],
          child: MaterialApp.router(routerConfig: router),
        ),
      );
      await tester.pumpAndSettle();

      expect(router.state.uri.path, AppRoutes.notes);
      expect(find.text('Notes'), findsWidgets);
    });
  });
}
