import 'package:flutter/material.dart';

import '../../../shared/widgets/route_placeholder_screen.dart';

/// Notes route placeholder (step 1.8).
class NotesPlaceholderScreen extends StatelessWidget {
  const NotesPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const RoutePlaceholderScreen(
      title: 'Notes',
      subtitle: 'Placeholder shell.',
    );
  }
}
