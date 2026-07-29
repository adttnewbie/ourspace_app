import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/config/app_config.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  AppConfig.ensureInitialized();
  runApp(const ProviderScope(child: OurSpaceApp()));
}
