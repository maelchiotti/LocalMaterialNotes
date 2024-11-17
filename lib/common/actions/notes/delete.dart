// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:localmaterialnotes/common/actions/notes/select.dart';
import 'package:localmaterialnotes/common/constants/constants.dart';
import 'package:localmaterialnotes/common/dialogs/confirmation_dialog.dart';
import 'package:localmaterialnotes/common/extensions/build_context_extension.dart';
import 'package:localmaterialnotes/models/note/note.dart';
import 'package:localmaterialnotes/providers/bin/bin_provider.dart';
import 'package:localmaterialnotes/providers/notes/notes/notes_provider.dart';
import 'package:localmaterialnotes/providers/notifiers.dart';
import 'package:localmaterialnotes/routing/routes/notes/notes_editor_route.dart';
import 'package:localmaterialnotes/routing/routes/shell/shell_route.dart';

/// Deletes the [note].
///
/// Returns `true` if the [note] was deleted, `false` otherwise.
///
/// First, asks for a confirmation if needed.
/// Finally, pops the route if the note was deleted from the editor page.
Future<bool> deleteNote(BuildContext context, WidgetRef ref, Note? note) async {
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

  currentNoteNotifier.value = null;

  final succeeded = await ref.read(notesProvider.notifier).delete(note);

  if (context.mounted && context.location == const NotesEditorRoute.empty().location) {
    context.pop();
  }

  return succeeded;
}

/// Deletes the [notes].
///
/// Returns `true` if the [notes] were deleted, `false` otherwise.
///
/// First, asks for a confirmation if needed.
Future<bool> deleteNotes(BuildContext context, WidgetRef ref, List<Note> notes) async {
  if (!await askForConfirmation(
    context,
    l.dialog_delete,
    l.dialog_delete_body(notes.length),
    l.dialog_delete,
  )) {
    return false;
  }

  final succeeded = await ref.read(notesProvider.notifier).deleteAll(notes);

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
Future<bool> permanentlyDeleteNote(BuildContext context, WidgetRef ref, Note? note) async {
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

  currentNoteNotifier.value = null;

  final succeeded = await ref.read(binProvider.notifier).permanentlyDelete(note);

  if (context.mounted && context.location == const NotesEditorRoute.empty().location) {
    context.pop();
  }

  return succeeded;
}

/// Permanently deletes the [notes].
///
/// Returns `true` if the [notes] were permanently deleted, `false` otherwise.
///
/// First, asks for a confirmation if needed.
Future<bool> permanentlyDeleteNotes(BuildContext context, WidgetRef ref, List<Note> notes) async {
  if (!await askForConfirmation(
    context,
    l.dialog_permanently_delete,
    l.dialog_permanently_delete_body(notes.length),
    l.dialog_permanently_delete,
    irreversible: true,
  )) {
    return false;
  }

  final succeeded = await ref.read(binProvider.notifier).permanentlyDeleteAll(notes);

  if (context.mounted) {
    exitNotesSelectionMode(context, ref);
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

  final succeeded = await ref.read(binProvider.notifier).empty();

  return succeeded;
}
