import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ourspace_app/features/pairing/presentation/widgets/hold_pairing_button.dart';

void main() {
  testWidgets('HoldPairingButton_fullDuration_callsComplete', (tester) async {
    var starts = 0;
    var completes = 0;
    var cancels = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: HoldPairingButton(
              enabled: true,
              busy: false,
              holdDuration: const Duration(milliseconds: 300),
              onHoldStart: () => starts++,
              onHoldCancel: () => cancels++,
              onHoldComplete: () => completes++,
              onProgress: (_) {},
            ),
          ),
        ),
      ),
    );

    final center = tester.getCenter(find.byType(HoldPairingButton));
    final gesture = await tester.startGesture(center);
    await tester.pump();
    expect(starts, 1);

    await tester.pump(const Duration(milliseconds: 350));
    await gesture.up();
    await tester.pump();

    expect(completes, 1);
    expect(cancels, 0);
  });

  testWidgets('HoldPairingButton_earlyRelease_cancelsNoComplete', (
    tester,
  ) async {
    var completes = 0;
    var cancels = 0;
    var starts = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: HoldPairingButton(
              enabled: true,
              busy: false,
              holdDuration: const Duration(milliseconds: 500),
              onHoldStart: () => starts++,
              onHoldCancel: () => cancels++,
              onHoldComplete: () => completes++,
              onProgress: (_) {},
            ),
          ),
        ),
      ),
    );

    final center = tester.getCenter(find.byType(HoldPairingButton));
    final gesture = await tester.startGesture(center);
    await tester.pump();
    expect(starts, 1);

    await tester.pump(const Duration(milliseconds: 100));
    await gesture.up();
    await tester.pump();

    expect(completes, 0);
    expect(cancels, 1);
  });
}
