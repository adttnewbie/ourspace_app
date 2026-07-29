import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/config/app_config.dart';

/// App entry (implementation-order 1.9).
///
/// Single [ProviderScope] root — tests override deps via [ProviderContainer]
/// / [ProviderScope.overrides] (see docs/testing.md). Do not nest another scope.
void main() {
  bootstrapAndRun();
}

/// Bootstrap for production run. Keeps [main] thin for the 1.9 DoD surface.
void bootstrapAndRun({List<Override> overrides = const []}) {
  WidgetsFlutterBinding.ensureInitialized();
  AppConfig.ensureInitialized();
  runApp(ProviderScope(overrides: overrides, child: const OurSpaceApp()));
}
