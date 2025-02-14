import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/note/note.dart';
import '../../../models/note/note_status.dart';
import '../../../providers/notes/notes_provider.dart';
import '../../../providers/notifiers/notifiers.dart';
import 'select.dart';

/// Toggles the pined status of the [note].
///
/// Returns `true` if the pined status of the [note] was toggled, `false` otherwise.
Future<bool> togglePinNote(BuildContext context, WidgetRef ref, {Note? note}) async {
  if (note == null) {
    return false;
  }

  await ref.read(notesProvider(status: NoteStatus.available, label: currentLabelFilter).notifier).togglePin(note);

  return false;
}

/// Toggles the pined status of the [notes].
Future<void> togglePinNotes(BuildContext context, WidgetRef ref, {required List<Note> notes}) async {
  await ref.read(notesProvider(status: NoteStatus.available, label: currentLabelFilter).notifier).togglePinAll(notes);

  if (context.mounted) {
    exitNotesSelectionMode(context, ref);
  }
}
