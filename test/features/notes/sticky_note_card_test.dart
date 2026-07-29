import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ourspace_app/core/theme/app_theme.dart';
import 'package:ourspace_app/features/notes/domain/sticky_note.dart';
import 'package:ourspace_app/features/notes/presentation/widgets/sticky_note_card.dart';

StickyNote _note({required bool canEdit}) {
  final t = DateTime.utc(2026, 7, 2);
  return StickyNote(
    id: 'n1',
    body: 'Isi note',
    color: 'pink',
    createdBy: 'm1',
    createdByNickname: 'Ae',
    createdAt: t,
    updatedAt: t,
    canEdit: canEdit,
  );
}

void main() {
  testWidgets('owner_sees_edit_and_delete', (tester) async {
    var edited = false;
    var deleted = false;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(
          body: StickyNoteCard(
            note: _note(canEdit: true),
            onEdit: () => edited = true,
            onDelete: () => deleted = true,
          ),
        ),
      ),
    );

    expect(find.bySemanticsLabel('Edit note'), findsOneWidget);
    expect(find.bySemanticsLabel('Hapus note'), findsOneWidget);
    await tester.tap(find.bySemanticsLabel('Edit note'));
    await tester.tap(find.bySemanticsLabel('Hapus note'));
    expect(edited, isTrue);
    expect(deleted, isTrue);
  });

  testWidgets('nonOwner_hides_edit_and_delete', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(
          body: StickyNoteCard(note: _note(canEdit: false)),
        ),
      ),
    );

    expect(find.bySemanticsLabel('Edit note'), findsNothing);
    expect(find.bySemanticsLabel('Hapus note'), findsNothing);
    expect(find.text('Isi note'), findsOneWidget);
    expect(find.textContaining('oleh Ae'), findsOneWidget);
  });
}
