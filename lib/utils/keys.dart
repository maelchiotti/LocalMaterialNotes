import 'package:flutter/foundation.dart';

// ignore_for_file: public_member_api_docs
// ignore_for_file: avoid_classes_with_only_static_members

/// Keys used to identify widgets in integration testing.
class Keys {
  // Drawer
  static const drawerNotesTab = Key('drawerNotesTab');
  static const drawerBinTab = Key('drawerBinTab');
  static const drawerSettingsTab = Key('drawerSettingsTab');

  // Dialogs
  static const dialogConfirmationConfirmButton = Key('dialogConfirmationConfirmButton');
  static const dialogConfirmationCancelButton = Key('dialogConfirmationCancelButton');

  // App bars
  static const appBarNotesBin = Key('appBarNotes');
  static const appBarEditor = Key('appBarEditor');
  static const appBarBin = Key('appBarBin');
  static const appBarSettingsMain = Key('appBarSettings');
  static const appBarSettingsMainSubpage = Key('appBarSettingsMainSubpage');

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

  // FABs
  static const fabAddNote = Key('fabAddNote');
  static const fabEmptyBin = Key('fabEmptyBin');

  // Pages
  static const pageNotes = Key('pageNotes');
  static const pageBin = Key('pageBin');
  static const pageEditor = Key('pageEditor');
  static const pageSettingsMain = Key('pageSettingsMain');

  // Notes list
  static const notesPageNotesList = Key('notesPageNotesList');
  static const notesPageNotesListListLayout = Key('notesPageNotesListListLayout');
  static const notesPageNotesListGridLayout = Key('notesPageNotesListGridLayout');

  // Notes tiles
  static Key noteTile(int index) => Key('noteTile$index');

  // Editor page
  static const editorTitleTextField = Key('editorTitleTextField');
  static const editorContentTextField = Key('editorContentTextField');
}
