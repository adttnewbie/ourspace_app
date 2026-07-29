import 'package:flutter/material.dart';

import '../../../shared/widgets/route_placeholder_screen.dart';

/// Settings route placeholder (step 1.8).
class SettingsPlaceholderScreen extends StatelessWidget {
  const SettingsPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const RoutePlaceholderScreen(
      title: 'Settings',
      subtitle: 'Placeholder shell.',
    );
  }
}
