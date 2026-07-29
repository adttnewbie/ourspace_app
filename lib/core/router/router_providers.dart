import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/session/presentation/session_controller.dart';
import 'app_router.dart';
import 'session_auth.dart';

/// Documented [GoRouter] dependency (docs/state-management.md, routing.md).
final routerProvider = Provider<GoRouter>((ref) {
  // Keep session controller alive and run SessionGate once (docs/routing.md §6).
  ref.watch(sessionControllerProvider);
  Future.microtask(
    () => ref.read(sessionControllerProvider.notifier).bootstrap(),
  );

  final sessionAuth = ref.watch(sessionAuthNotifierProvider);
  final router = createAppRouter(sessionAuth: sessionAuth);
  ref.onDispose(router.dispose);
  return router;
});
