import 'package:flutter/material.dart';

import '../../../shared/widgets/route_placeholder_screen.dart';

/// Pairing route placeholder (step 1.8 — no pairing logic).
class PairingPlaceholderScreen extends StatelessWidget {
  const PairingPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const RoutePlaceholderScreen(
      title: 'Pairing',
      subtitle: 'Placeholder. Ritual pairing menyusul.',
    );
  }
}
