import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:localmaterialnotes/common/widgets/notes/note_tile.dart';
import 'package:patrol/patrol.dart';

import '../utils.dart';

void main() {
  patrolTest(
    'Change the layout of the notes list',
    ($) async {
      await $.pumpWidgetAndSettle(await app);

      // The layout should be the list view
      expect($(Icons.grid_view), findsOne);
      expect($(#notesPageNotesListListLayout), findsOne);
      expect($(#notesPageNotesListGridLayout), findsNothing);

      // Switch the layout to the grid view
      await $(#appBarLayoutIconButton).tap();

      // The layout should be the grid view
      expect($(Icons.view_list), findsOne);
      expect($(#notesPageNotesListListLayout), findsNothing);
      expect($(#notesPageNotesListGridLayout), findsOne);

      // Switch the layout to the list view
      await $(#appBarLayoutIconButton).tap();

      // The layout should be the list view
      expect($(Icons.grid_view), findsOne);
      expect($(#notesPageNotesListListLayout), findsOne);
      expect($(#notesPageNotesListGridLayout), findsNothing);
    },
  );

  patrolTest(
    'Use the default sort method by date',
    ($) async {
      await $.pumpWidgetAndSettle(await app);

      // Open the sort method menu
      await $(#appBarSortIconButton).tap();

      // The sort method by date should be enabled
      expect(
        $(#sortDateMenuItem).$(ListTile).which<ListTile>((listTile) => listTile.selected),
        findsOne,
      );
      // The sort method by title should be disabled
      expect(
        $(#sortTitleMenuItem).$(ListTile).which<ListTile>((listTile) => !listTile.selected),
        findsOne,
      );
      // The sort method in ascending order should be disabled
      expect(
        $(#sortAscendingMenuItem).$(Checkbox).which<Checkbox>((checkbox) => checkbox.value != null && !checkbox.value!),
        findsOne,
      );

      // Close the sort method menu
      $.native.pressBack();

      // The 1st note should be the most recent
      expect(
        $(#noteTile0).which<NoteTile>((noteTile) => noteTile.note.title == 'Note 0'),
        findsOne,
      );
      // The 3rd note should be the 3rd most recent
      expect(
        $(#noteTile2).which<NoteTile>((noteTile) => noteTile.note.title == 'Note 2'),
        findsOne,
      );
    },
  );

  patrolTest(
    'Use the sort method by title',
    ($) async {
      await $.pumpWidgetAndSettle(await app);

      // Open the sort method menu
      await $(#appBarSortIconButton).tap();

      // Switch the sort method to sort by title
      await $(#sortTitleMenuItem).tap();

      // Open the sort method menu again to check the menu items
      await $(#appBarSortIconButton).tap();

      // The sort method by date should be disabled
      expect(
        $(#sortDateMenuItem).$(ListTile).which<ListTile>((listTile) => !listTile.selected),
        findsOne,
      );
      // The sort method by title should be enabled
      expect(
        $(#sortTitleMenuItem).$(ListTile).which<ListTile>((listTile) => listTile.selected),
        findsOne,
      );
      // The sort method in ascending order should be enabled
      expect(
        $(#sortAscendingMenuItem).$(Checkbox).which<Checkbox>((checkbox) => checkbox.value != null && checkbox.value!),
        findsOne,
      );

      // Close the sort method menu
      $.native.pressBack();

      // The 1st note should be the first in alphabetical order
      expect(
        $(#noteTile0).which<NoteTile>((noteTile) => noteTile.note.title == 'Note 0'),
        findsOne,
      );
      // The 3rd note should be the 3rd in alphabetical order
      expect(
        $(#noteTile2).which<NoteTile>((noteTile) => noteTile.note.title == 'Note 10'),
        findsOne,
      );
    },
  );

  patrolTest(
    'Use the default sort method by date but in ascending order',
    ($) async {
      await $.pumpWidgetAndSettle(await app);

      // Open the sort method menu
      await $(#appBarSortIconButton).tap();

      // Sort in ascending order
      await $(#sortAscendingMenuItem).tap();

      // Open the sort method menu again to check the menu items
      await $(#appBarSortIconButton).tap();

      // The sort method by date should be enabled
      expect(
        $(#sortDateMenuItem).$(ListTile).which<ListTile>((listTile) => listTile.selected),
        findsOne,
      );
      // The sort method by title should be disabled
      expect(
        $(#sortTitleMenuItem).$(ListTile).which<ListTile>((listTile) => !listTile.selected),
        findsOne,
      );
      // The sort method in ascending order should be enabled
      expect(
        $(#sortAscendingMenuItem).$(Checkbox).which<Checkbox>((checkbox) => checkbox.value != null && checkbox.value!),
        findsOne,
      );

      // Close the sort method menu
      $.native.pressBack();

      // The 1st note should be the least recent
      expect(
        $(#noteTile0).which<NoteTile>((noteTile) => noteTile.note.title == 'Note 99'),
        findsOne,
      );
      // The 3rd note should be the 3rd least recent
      expect(
        $(#noteTile2).which<NoteTile>((noteTile) => noteTile.note.title == 'Note 97'),
        findsOne,
      );
    },
  );

  patrolTest(
    'Use the sort method by title but in descending order',
    ($) async {
      await $.pumpWidgetAndSettle(await app);

      // Open the sort method menu
      await $(#appBarSortIconButton).tap();

      // Switch the sort method to sort by title
      await $(#sortTitleMenuItem).tap();

      // Open the sort method menu again
      await $(#appBarSortIconButton).tap();

      // Sort in descending order
      await $(#sortAscendingMenuItem).tap();

      // Open the sort method menu again to check the menu items
      await $(#appBarSortIconButton).tap();

      // The sort method by date should be disabled
      expect(
        $(#sortDateMenuItem).$(ListTile).which<ListTile>((listTile) => !listTile.selected),
        findsOne,
      );
      // The sort method by title should be enabled
      expect(
        $(#sortTitleMenuItem).$(ListTile).which<ListTile>((listTile) => listTile.selected),
        findsOne,
      );
      // The sort method in ascending order should be disabled
      expect(
        $(#sortAscendingMenuItem).$(Checkbox).which<Checkbox>((checkbox) => checkbox.value != null && !checkbox.value!),
        findsOne,
      );

      // Close the sort method menu
      $.native.pressBack();

      // The 1st note should be the last in alphabetical order
      expect(
        $(#noteTile0).which<NoteTile>((noteTile) => noteTile.note.title == 'Note 99'),
        findsOne,
      );
      // The 3rd note should be the 3rd last in alphabetical order
      expect(
        $(#noteTile2).which<NoteTile>((noteTile) => noteTile.note.title == 'Note 97'),
        findsOne,
      );
    },
  );

  // Skipped because I didn't find a way to write text in the search anchor.
  patrolTest(
    skip: true,
    'Search the notes',
    ($) async {
      await $.pumpWidgetAndSettle(await app);

      // Open the search view
      await $(#searchIconButton).tap();

      // Find the search anchor
      expect($(#searchViewSearchAnchor), findsOne);

      // The search text in the search anchor should be empty
      expect(
        $(#searchViewSearchAnchor).which<SearchAnchor>(
            (searchAnchor) => searchAnchor.searchController != null && searchAnchor.searchController!.text == ''),
        findsOne,
      );

      // Update the search text
      await $(#searchViewSearchAnchor).$(RichText).enterText('1');

      // The search text in the search anchor should have changed
      expect(
        $(#searchViewSearchAnchor).which<SearchAnchor>(
            (searchAnchor) => searchAnchor.searchController != null && searchAnchor.searchController!.text == '1'),
        findsOne,
      );

      // The 1st note should be the 'Note 1' note
      expect(
        $(#noteTile0).which<NoteTile>((noteTile) => noteTile.note.title == 'Note 1'),
        findsOne,
      );
      // The 2nd note should be the 'Note 10' note
      expect(
        $(#noteTile2).which<NoteTile>((noteTile) => noteTile.note.title == 'Note 10'),
        findsOne,
      );

      // Update the search text again
      await $(#searchViewSearchAnchor).$(RichText).enterText('0');

      // The search text in the search anchor should have changed again
      expect(
        $(#searchViewSearchAnchor).which<SearchAnchor>(
            (searchAnchor) => searchAnchor.searchController != null && searchAnchor.searchController!.text == '10'),
        findsOne,
      );

      // The 1st note should be the 'Note 10' note
      expect(
        $(#noteTile0).which<NoteTile>((noteTile) => noteTile.note.title == 'Note 10'),
        findsOne,
      );
      // There should only be one note found by the search
      expect($(#noteTile1), findsNothing);
    },
  );
}
