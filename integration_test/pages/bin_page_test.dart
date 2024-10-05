import 'package:flutter_test/flutter_test.dart';
import 'package:localmaterialnotes/common/widgets/notes/note_tile.dart';
import 'package:patrol/patrol.dart';

import '../utils.dart';

void main() {
  patrolTest('Opens the bin page', ($) async {
    await $.pumpWidgetAndSettle(await app);
    await openBin($);

    // Find the layout icon button
    expect($(#appBarLayoutIconButton), findsOne);

    // Find the sort icon button
    expect($(#appBarSortIconButton), findsOne);

    // Find the search icon button
    expect($(#appBarSearchIconButton), findsOne);

    // Find the notes list
    expect($(#notesPageNotesList), findsOne);

    // Find the FAB to empty the bin
    expect($(#fabEmptyBin), findsOne);
  });

  patrolTest(
    'Finds the notes tiles in the bin page',
    ($) async {
      await $.pumpWidgetAndSettle(await app);
      await openBin($);

      // Find the 1st note tile that should be visible
      expect(
        $(#noteTile0).which<NoteTile>((noteTile) => noteTile.note.title == 'Deleted note 0'),
        findsOne,
      );

      // Scroll to find the 50th note tile
      expect(
        await $(#noteTile49)
            .which<NoteTile>((noteTile) => noteTile.note.title == 'Deleted note 49')
            .scrollTo(maxScrolls: 50),
        findsOne,
      );

      // Scroll to find the 100th and last note tile
      expect(
        await $(#noteTile99)
            .which<NoteTile>((noteTile) => noteTile.note.title == 'Deleted note 99')
            .scrollTo(maxScrolls: 50),
        findsOne,
      );
    },
  );
}
