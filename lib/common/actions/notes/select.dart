import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/note/note.dart';
import '../../../providers/bin/bin_provider.dart';
import '../../../providers/notes/notes_provider.dart';
import '../../../providers/notifiers/notifiers.dart';

/// Toggles the select status of the [note].
void toggleSelectNote(WidgetRef ref, Note note) {
  if (note.deleted) {
    note.selected ? ref.read(binProvider.notifier).unselect(note) : ref.read(binProvider.notifier).select(note);
  } else {
    note.selected
        ? ref.read(notesProvider(label: currentLabelFilter).notifier).unselect(note)
        : ref.read(notesProvider(label: currentLabelFilter).notifier).select(note);
  }
}

/// Selects all the notes.
///
/// Depending on the current route, selects either the notes from the notes page or those from the bin page.
void selectAllNotes(BuildContext context, WidgetRef ref, {bool notesPage = true}) {
  notesPage
      ? ref.read(notesProvider(label: currentLabelFilter).notifier).selectAll()
      : ref.read(binProvider.notifier).selectAll();
}

/// Unselects all the notes.
///
/// Depending on the current route, unselects either the notes from the notes page or those from the bin page.
void unselectAllNotes(BuildContext context, WidgetRef ref, {bool notesPage = true}) {
  notesPage
      ? ref.read(notesProvider(label: currentLabelFilter).notifier).unselectAll()
      : ref.read(binProvider.notifier).unselectAll();
}

/// Exits the notes selection mode.
///
/// First unselects all the notes.
void exitNotesSelectionMode(BuildContext context, WidgetRef ref, {bool notesPage = true}) {
  unselectAllNotes(context, ref, notesPage: notesPage);

  isNotesSelectionModeNotifier.value = false;
}
