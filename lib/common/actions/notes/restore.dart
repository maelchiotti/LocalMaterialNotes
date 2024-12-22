import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'select.dart';
import '../../constants/constants.dart';
import '../../dialogs/confirmation_dialog.dart';
import '../../../models/note/note.dart';
import '../../../providers/bin/bin_provider.dart';
import '../../../providers/notifiers/notifiers.dart';

/// Restores the [note].
///
/// Returns `true` if the [note] was restored, `false` otherwise.
///
/// First, asks for a confirmation if needed.
/// Finally, pops the route if the note was restored from the editor page.
Future<bool> restoreNote(BuildContext context, WidgetRef ref, Note? note, [bool pop = false]) async {
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
    Navigator.pop(context);
  }

  currentNoteNotifier.value = null;

  final succeeded = await ref.read(binProvider.notifier).restore(note);

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
Future<bool> restoreNotes(BuildContext context, WidgetRef ref, List<Note> notes) async {
  if (!await askForConfirmation(
    context,
    l.dialog_restore,
    l.dialog_restore_body(notes.length),
    l.dialog_restore,
  )) {
    return false;
  }

  final succeeded = await ref.read(binProvider.notifier).restoreAll(notes);

  if (context.mounted) {
    exitNotesSelectionMode(context, ref);
  }

  return succeeded;
}
