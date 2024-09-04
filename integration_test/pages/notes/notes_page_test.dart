import 'package:flutter_test/flutter_test.dart';
import 'package:localmaterialnotes/common/widgets/notes/note_tile.dart';
import 'package:patrol/patrol.dart';

import '../../utils.dart';

void main() {
  patrolTest('Initializes the notes page', ($) async {
    await $.pumpWidgetAndSettle(await appInitialized);

    // Find the layout icon button
    expect($(#notesPageLayoutIconButton), findsOne);

    // Find the sort icon button
    expect($(#notesPageSortIconButton), findsOne);

    // Find the search icon button
    expect($(#notesPageSearchIconButton), findsOne);

    // Find the notes list
    expect($(#notesPageNotesList), findsOne);

    // Find the FAB to add a note
    expect($(#fabAddNote), findsOne);
  });

  patrolTest(
    'Finds the notes tiles in the notes page',
    ($) async {
      await $.pumpWidgetAndSettle(await appInitialized);

      // Find the 1st note tile that should be visible
      expect(
        $(#notesPageNoteTile0).which<NoteTile>((noteTile) => noteTile.note.title == 'Note 0'),
        findsOne,
      );

      // Scroll to find the 50th note tile
      expect(
        await $(#notesPageNoteTile49)
            .which<NoteTile>((noteTile) => noteTile.note.title == 'Note 49')
            .scrollTo(maxScrolls: 50),
        findsOne,
      );

      // Scroll to find the 100th and last note tile
      expect(
        await $(#notesPageNoteTile99)
            .which<NoteTile>((noteTile) => noteTile.note.title == 'Note 99')
            .scrollTo(maxScrolls: 50),
        findsOne,
      );
    },
  );
}
