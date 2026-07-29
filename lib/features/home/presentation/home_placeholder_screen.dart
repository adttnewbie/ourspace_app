import 'package:flutter/material.dart';

import '../../../shared/widgets/route_placeholder_screen.dart';

/// Home route placeholder (step 1.8).
class HomePlaceholderScreen extends StatelessWidget {
  const HomePlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const RoutePlaceholderScreen(
      title: 'Home',
      subtitle: 'Placeholder shell.',
    );
  }
}
