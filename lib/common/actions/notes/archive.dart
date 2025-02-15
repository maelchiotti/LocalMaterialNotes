import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/note/note.dart';
import '../../../models/note/note_status.dart';
import '../../../providers/notes/notes_provider.dart';
import '../../../providers/notifiers/notifiers.dart';
import '../../constants/constants.dart';
import '../../dialogs/confirmation_dialog.dart';
import 'select.dart';

/// Archives the [note].
///
/// Returns `true` if the [note] was archived, `false` otherwise.
///
/// First, asks for a confirmation if needed.
/// Finally, pops the route if the note was archived from the editor page.
Future<bool> archiveNote(BuildContext context, WidgetRef ref, {required Note note, bool pop = false}) async {
  if (!await askForConfirmation(
    context,
    l.dialog_archive,
    l.dialog_archive_body(1),
    l.dialog_archive,
  )) {
    return false;
  }

  if (context.mounted && pop) {
    Navigator.pop(context);
  }

  currentNoteNotifier.value = null;

  final succeeded = await ref
      .read(notesProvider(status: NoteStatus.available, label: currentLabelFilter).notifier)
      .setArchived([note], true);

  if (!succeeded) {
    return false;
  }

  return true;
}

/// Archives the [notes].
///
/// Returns `true` if the [notes] were archived, `false` otherwise.
///
/// First, asks for a confirmation if needed.
Future<bool> archiveNotes(BuildContext context, WidgetRef ref, {required List<Note> notes}) async {
  if (!await askForConfirmation(
    context,
    l.dialog_archive,
    l.dialog_archive_body(notes.length),
    l.dialog_archive,
  )) {
    return false;
  }

  final succeeded = await ref
      .read(notesProvider(status: NoteStatus.available, label: currentLabelFilter).notifier)
      .setArchived(notes, true);

  if (context.mounted) {
    exitNotesSelectionMode(context, ref, notesStatus: NoteStatus.available);
  }

  return succeeded;
}
