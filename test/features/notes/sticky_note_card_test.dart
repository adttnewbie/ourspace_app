import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ourspace_app/core/theme/app_theme.dart';
import 'package:ourspace_app/features/notes/domain/sticky_note.dart';
import 'package:ourspace_app/features/notes/presentation/widgets/sticky_note_card.dart';

StickyNote _note({bool canEdit = true}) {
  final t = DateTime.utc(2026, 7, 2, 8, 5);
  return StickyNote(
    id: 'note_1',
    body: 'Aku kangen es krim kemarin.',
    color: 'pink',
    createdBy: 'member_a',
    createdByNickname: 'Ae',
    createdAt: t,
    updatedAt: t,
    canEdit: canEdit,
  );
}

void main() {
  group('StickyNoteCard ownership UI (step 2.4)', () {
    testWidgets('owner_sees_edit_and_delete', (tester) async {
      var edit = 0;
      var del = 0;
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: Scaffold(
            body: StickyNoteCard(
              note: _note(canEdit: true),
              onEdit: () => edit++,
              onDelete: () => del++,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.edit_outlined), findsOneWidget);
      expect(find.byIcon(Icons.delete_outline), findsOneWidget);
      expect(find.text('oleh Ae'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.edit_outlined));
      await tester.pump();
      expect(edit, 1);

      await tester.tap(find.byIcon(Icons.delete_outline));
      await tester.pump();
      expect(del, 1);
    });

    testWidgets('nonOwner_hides_edit_and_delete', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: Scaffold(
            body: StickyNoteCard(
              note: _note(canEdit: false),
              onEdit: () {},
              onDelete: () {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.edit_outlined), findsNothing);
      expect(find.byIcon(Icons.delete_outline), findsNothing);
      expect(find.textContaining('Aku kangen'), findsOneWidget);
    });
  });
}
