import 'package:flutter/foundation.dart';

// ignore_for_file: public_member_api_docs
// ignore_for_file: avoid_classes_with_only_static_members

/// Keys used to identify widgets in integration testing.
class Keys {
  // App bars
  static const appBarNotes = Key('appBarNotes');

  // Notes page
  static const fabAddNote = Key('fabAddNote');

  // App bars icon buttons
  static const notesPageLayoutIconButton = Key('notesPageLayoutIconButton');
  static const notesPageSortIconButton = Key('notesPageSortIconButton');
  static const notesPageSearchIconButton = Key('notesPageSearchIconButton');

  // Sort method popup menu items
  static const notesPageSortDateMenuItem = Key('notesPageSortDateMenuItem');
  static const notesPageSortTitleMenuItem = Key('notesPageSortTitleMenuItem');
  static const notesPageSortAscendingMenuItem = Key('notesPageSortAscendingMenuItem');

  // Search view
  static const notesPageSearchViewSearchAnchor = Key('notesPageSearchViewSearchAnchor');

  // Notes list
  static const notesPageNotesList = Key('notesPageNotesList');
  static const notesPageNotesListListLayout = Key('notesPageNotesListListLayout');
  static const notesPageNotesListGridLayout = Key('notesPageNotesListGridLayout');

  // Notes tile
  static Key notesPageNoteTile(int index) => Key('notesPageNoteTile$index');
}
