import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localmaterialnotes/models/note/note.dart';
import 'package:localmaterialnotes/providers/bin/bin_provider.dart';
import 'package:localmaterialnotes/providers/notes/notes_provider.dart';
import 'package:localmaterialnotes/providers/notifiers/notifiers.dart';

/// Toggles the select status of the [note].
void toggleSelectNote(WidgetRef ref, Note note) {
  if (note.deleted) {
    note.selected ? ref.read(binProvider.notifier).unselect(note) : ref.read(binProvider.notifier).select(note);
  } else {
    note.selected ? ref.read(notesProvider.notifier).unselect(note) : ref.read(notesProvider.notifier).select(note);
  }
}

/// Selects all the notes.
///
/// Depending on the current route, selects either the notes from the notes page or those from the bin page.
void selectAllNotes(BuildContext context, WidgetRef ref, {bool notesPage = true}) {
  notesPage ? ref.read(notesProvider.notifier).selectAll() : ref.read(binProvider.notifier).selectAll();
}

/// Unselects all the notes.
///
/// Depending on the current route, unselects either the notes from the notes page or those from the bin page.
void unselectAllNotes(BuildContext context, WidgetRef ref, {bool notesPage = true}) {
  notesPage ? ref.read(notesProvider.notifier).unselectAll() : ref.read(binProvider.notifier).unselectAll();
}

/// Exits the notes selection mode.
///
/// First unselects all the notes.
void exitNotesSelectionMode(BuildContext context, WidgetRef ref) {
  unselectAllNotes(context, ref);

  isNotesSelectionModeNotifier.value = false;
}
