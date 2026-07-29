import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'app_router.dart';
import 'session_auth.dart';

/// Documented [GoRouter] dependency (docs/state-management.md, routing.md).
final routerProvider = Provider<GoRouter>((ref) {
  final sessionAuth = ref.watch(sessionAuthNotifierProvider);
  final router = createAppRouter(sessionAuth: sessionAuth);
  ref.onDispose(router.dispose);
  return router;
});
