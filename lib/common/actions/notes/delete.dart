import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/note/note.dart';
import '../../../models/note/note_status.dart';
import '../../../providers/notes/notes_provider.dart';
import '../../../providers/notifiers/notifiers.dart';
import '../../constants/constants.dart';
import '../../dialogs/confirmation_dialog.dart';
import 'select.dart';

/// Deletes the [note].
///
/// Returns `true` if the [note] was deleted, `false` otherwise.
///
/// First, asks for a confirmation if needed.
/// Finally, pops the route if the note was deleted from the editor page.
Future<bool> deleteNote(BuildContext context, WidgetRef ref, {Note? note, bool pop = false}) async {
  if (note == null) {
    return false;
  }

  if (!await askForConfirmation(
    context,
    l.dialog_delete,
    l.dialog_delete_body(1),
    l.dialog_delete,
  )) {
    return false;
  }

  if (context.mounted && pop) {
    Navigator.pop(context);
  }

  currentNoteNotifier.value = null;

  final succeeded =
      await ref.read(notesProvider(status: NoteStatus.available, label: currentLabelFilter).notifier).delete(note);

  if (!succeeded) {
    return false;
  }

  return true;
}

/// Deletes the [notes].
///
/// Returns `true` if the [notes] were deleted, `false` otherwise.
///
/// First, asks for a confirmation if needed.
Future<bool> deleteNotes(BuildContext context, WidgetRef ref, {required List<Note> notes}) async {
  if (!await askForConfirmation(
    context,
    l.dialog_delete,
    l.dialog_delete_body(notes.length),
    l.dialog_delete,
  )) {
    return false;
  }

  final succeeded =
      await ref.read(notesProvider(status: NoteStatus.available, label: currentLabelFilter).notifier).deleteAll(notes);

  if (context.mounted) {
    exitNotesSelectionMode(context, ref);
  }

  return succeeded;
}

/// Permanently deletes the [note].
///
/// Returns `true` if the [note] was permanently deleted, `false` otherwise.
///
/// First, asks for a confirmation if needed.
/// Finally, pops the route if the note was deleted from the editor page.
Future<bool> permanentlyDeleteNote(BuildContext context, WidgetRef ref, {Note? note, bool pop = false}) async {
  if (note == null) {
    return false;
  }

  if (!await askForConfirmation(
    context,
    l.dialog_permanently_delete,
    l.dialog_permanently_delete_body(1),
    l.dialog_permanently_delete,
    irreversible: true,
  )) {
    return false;
  }

  if (context.mounted && pop) {
    Navigator.pop(context);
  }

  currentNoteNotifier.value = null;

  final succeeded = await ref.read(notesProvider(status: NoteStatus.deleted).notifier).permanentlyDelete(note);

  if (!succeeded) {
    return false;
  }

  return true;
}

/// Permanently deletes the [notes].
///
/// Returns `true` if the [notes] were permanently deleted, `false` otherwise.
///
/// First, asks for a confirmation if needed.
Future<bool> permanentlyDeleteNotes(BuildContext context, WidgetRef ref, {required List<Note> notes}) async {
  if (!await askForConfirmation(
    context,
    l.dialog_permanently_delete,
    l.dialog_permanently_delete_body(notes.length),
    l.dialog_permanently_delete,
    irreversible: true,
  )) {
    return false;
  }

  final succeeded = await ref.read(notesProvider(status: NoteStatus.deleted).notifier).permanentlyDeleteAll(notes);

  if (context.mounted) {
    exitNotesSelectionMode(context, ref, notesPage: false);
  }

  return succeeded;
}

/// Empties the bin by deleting every note inside.
///
/// First, asks for a confirmation if needed.
/// Exits the selection mode.
Future<bool> emptyBin(BuildContext context, WidgetRef ref) async {
  if (!await askForConfirmation(
    context,
    l.dialog_empty_bin,
    l.dialog_empty_bin_body,
    l.dialog_empty_bin,
    irreversible: true,
  )) {
    return false;
  }

  isNotesSelectionModeNotifier.value = false;

  final succeeded = await ref.read(notesProvider(status: NoteStatus.deleted).notifier).emptyBin();

  return succeeded;
}
