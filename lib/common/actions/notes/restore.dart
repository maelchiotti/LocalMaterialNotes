import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/note/note.dart';
import '../../../models/note/note_status.dart';
import '../../../providers/notes/notes_provider.dart';
import '../../../providers/notifiers/notifiers.dart';
import '../../constants/constants.dart';
import '../../dialogs/confirmation_dialog.dart';
import 'select.dart';

/// Restores the [note].
///
/// Returns `true` if the [note] was restored, `false` otherwise.
///
/// First, asks for a confirmation if needed.
/// Finally, pops the route if the note was restored from the editor page.
Future<bool> restoreNote(BuildContext context, WidgetRef ref, {Note? note, bool pop = false}) async {
  if (note == null) {
    return false;
  }

  if (!await askForConfirmation(
    context,
    l.dialog_restore,
    l.dialog_restore_body(1),
    l.dialog_restore,
  )) {
    return false;
  }

  if (context.mounted && pop) {
    currentNoteNotifier.value = null;
    Navigator.pop(context);
  }

  final succeeded = await ref.read(notesProvider(status: NoteStatus.deleted).notifier).restore(note);

  if (!succeeded) {
    return false;
  }

  return true;
}

/// Restores the [notes].
///
/// Returns `true` if the [notes] were restored, `false` otherwise.
///
/// First, asks for a confirmation if needed.
Future<bool> restoreNotes(BuildContext context, WidgetRef ref, {required List<Note> notes}) async {
  if (!await askForConfirmation(
    context,
    l.dialog_restore,
    l.dialog_restore_body(notes.length),
    l.dialog_restore,
  )) {
    return false;
  }

  final succeeded = await ref.read(notesProvider(status: NoteStatus.deleted).notifier).restoreAll(notes);

  if (context.mounted) {
    exitNotesSelectionMode(context, ref, notesPage: false);
  }

  return succeeded;
}
