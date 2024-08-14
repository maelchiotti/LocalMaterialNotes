import 'package:flutter/foundation.dart';

/// Keys used to identify widgets in integration testing.
class Keys {
  // App bars
  static const appBarNotes = Key('appBarNotes');

  // FABs
  static const fabAddNote = Key('fabAddNote');

  // Notes page
  static const notesPageLayoutIconButton = Key('notesPageLayoutIconButton');
  static const notesPageSortIconButton = Key('notesPageSortIconButton');
  static const notesPageSearchIconButton = Key('notesPageSearchIconButton');
  static const notesPageNotesList = Key('notesPageNotesList');
  static const notesPageNoteTile = Key('notesPageNoteTile');
}
