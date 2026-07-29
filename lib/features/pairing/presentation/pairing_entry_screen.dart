import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../session/presentation/session_controller.dart';
import '../../session/presentation/session_gate_screen.dart';
import 'pairing_placeholder_screen.dart';

/// Pairing route entry: gate while checking/retry, placeholder when unauthenticated.
class PairingEntryScreen extends ConsumerWidget {
  const PairingEntryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionControllerProvider);
    switch (session.status) {
      case SessionPhase.unknown:
      case SessionPhase.temporaryError:
        return const SessionGateScreen();
      case SessionPhase.unauthenticated:
      case SessionPhase.authenticated:
        return const PairingPlaceholderScreen();
    }
  }
}
