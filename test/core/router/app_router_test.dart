import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ourspace_app/core/router/app_router.dart';
import 'package:ourspace_app/core/router/app_routes.dart';
import 'package:ourspace_app/core/router/session_auth.dart';
import 'package:ourspace_app/core/storage/secure_storage.dart';

void main() {
  group('GoRouter redirects (step 1.8 DoD)', () {
    testWidgets('unauthenticated_shellPath_redirectsToPairing', (tester) async {
      final auth = SessionAuthNotifier(FakeSecureStorage());
      auth.setStatus(SessionAuthStatus.unauthenticated);

      final router = createAppRouter(
        sessionAuth: auth,
        initialLocation: AppRoutes.home,
      );
      addTearDown(router.dispose);

      await tester.pumpWidget(
        MaterialApp.router(routerConfig: router),
      );
      await tester.pumpAndSettle();

      expect(router.state.uri.path, AppRoutes.pairing);
      expect(find.text('Pairing'), findsOneWidget);
    });

    testWidgets('authenticated_pairing_redirectsToHome', (tester) async {
      final auth = SessionAuthNotifier(FakeSecureStorage());
      auth.setStatus(SessionAuthStatus.authenticated);

      final router = createAppRouter(
        sessionAuth: auth,
        initialLocation: AppRoutes.pairing,
      );
      addTearDown(router.dispose);

      await tester.pumpWidget(
        MaterialApp.router(routerConfig: router),
      );
      await tester.pumpAndSettle();

      expect(router.state.uri.path, AppRoutes.home);
      expect(find.text('Home'), findsWidgets);
    });

    testWidgets('authenticated_notes_staysOnNotes', (tester) async {
      final auth = SessionAuthNotifier(FakeSecureStorage());
      auth.setStatus(SessionAuthStatus.authenticated);

      final router = createAppRouter(
        sessionAuth: auth,
        initialLocation: AppRoutes.notes,
      );
      addTearDown(router.dispose);

      await tester.pumpWidget(
        MaterialApp.router(routerConfig: router),
      );
      await tester.pumpAndSettle();

      expect(router.state.uri.path, AppRoutes.notes);
      expect(find.text('Notes'), findsWidgets);
    });
  });
}
