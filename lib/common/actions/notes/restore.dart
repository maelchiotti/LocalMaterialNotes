import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/note/note.dart';
import '../../../models/note/note_status.dart';
import '../../../providers/notes/notes_provider.dart';
import '../../../providers/notifiers/notifiers.dart';
import '../../constants/constants.dart';
import '../../dialogs/confirmation_dialog.dart';
import '../../ui/snack_bar_utils.dart';
import 'delete.dart';
import 'select.dart';

/// Restores the [note].
///
/// Returns `true` if the [note] was restored, `false` otherwise.
Future<bool> restoreNote(
  BuildContext context,
  WidgetRef ref, {
  required Note note,
  bool pop = false,
  bool cancel = true,
}) async {
  if (!await askForConfirmation(context, l.dialog_restore, l.dialog_restore_body(1), l.dialog_restore)) {
    return false;
  }

  if (context.mounted && pop) {
    // Use the root navigator key to avoid popping to the lock screen
    Navigator.pop(rootNavigatorKey.currentContext!);
  }

  currentNoteNotifier.value = null;

  final succeeded = await ref.read(notesProvider(status: NoteStatus.deleted).notifier).setDeleted([note], false);

  if (succeeded && cancel) {
    SnackBarUtils().show(
      text: l.snack_bar_restored(1),
      onCancel: (globalRef) async => await deleteNote(context, globalRef, note: note, cancel: false),
    );
  }

  return succeeded;
}

/// Restores the [notes].
///
/// Returns `true` if the [notes] were restored, `false` otherwise.
Future<bool> restoreNotes(BuildContext context, WidgetRef ref, {required List<Note> notes, bool cancel = true}) async {
  if (!await askForConfirmation(context, l.dialog_restore, l.dialog_restore_body(notes.length), l.dialog_restore)) {
    return false;
  }

  final succeeded = await ref.read(notesProvider(status: NoteStatus.deleted).notifier).setDeleted(notes, false);

  if (context.mounted) {
    exitNotesSelectionMode(context, ref, notesStatus: NoteStatus.deleted);
  }

  if (succeeded && cancel) {
    SnackBarUtils().show(
      text: l.snack_bar_restored(notes.length),
      onCancel: (globalRef) async => await deleteNotes(context, globalRef, notes: notes, cancel: false),
    );
  }

  return succeeded;
}
