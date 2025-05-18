import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/note/note.dart';
import '../../../models/note/note_status.dart';
import '../../../providers/notes/notes_provider.dart';
import '../../../providers/notifiers/notifiers.dart';

/// Toggles the select status of the [note].
void toggleSelectNote(WidgetRef ref, {required Note note}) {
  ref.read(notesProvider(status: note.status, label: currentLabelFilter).notifier).toggleSelect(note);
}

/// Selects all the notes.
///
/// Depending on the current route, selects either the notes from the notes page or those from the bin page.
void selectAllNotes(BuildContext context, WidgetRef ref, {required NoteStatus notesStatus}) {
  ref.read(notesProvider(status: notesStatus, label: currentLabelFilter).notifier).setSelectAll(true);
}

/// Unselects all the notes.
///
/// Depending on the current route, unselects either the notes from the notes page or those from the bin page.
void unselectAllNotes(BuildContext context, WidgetRef ref, {required NoteStatus notesStatus}) {
  ref.read(notesProvider(status: notesStatus, label: currentLabelFilter).notifier).setSelectAll(false);
}

/// Exits the notes selection mode.
///
/// First unselects all the notes.
void exitNotesSelectionMode(BuildContext context, WidgetRef ref, {required NoteStatus notesStatus}) {
  unselectAllNotes(context, ref, notesStatus: notesStatus);

  isNotesSelectionModeNotifier.value = false;
}
