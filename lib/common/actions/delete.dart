import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:localmaterialnotes/common/constants/constants.dart';
import 'package:localmaterialnotes/common/routing/router_route.dart';
import 'package:localmaterialnotes/common/widgets/dialogs/confirmation_dialog.dart';
import 'package:localmaterialnotes/models/note/note.dart';
import 'package:localmaterialnotes/providers/bin/bin_provider.dart';
import 'package:localmaterialnotes/providers/notes/notes_provider.dart';
import 'package:localmaterialnotes/providers/notifiers.dart';

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
    localizations.dialog_delete,
    localizations.dialog_delete_body_single,
    localizations.dialog_delete,
  )) {
    return false;
  }

  currentNoteNotifier.value = null;

  await ref.read(notesProvider.notifier).delete(note);

  if (context.mounted && RouterRoute.isEditor) {
    context.pop();
  }

  return true;
}

/// Deletes the [notes].
///
/// Returns `true` if the [notes] were deleted, `false` otherwise.
///
/// First, asks for a confirmation if needed.
Future<bool> deleteNotes(WidgetRef ref, List<Note> notes) async {
  if (!await askForConfirmation(
    localizations.dialog_delete,
    localizations.dialog_delete_body(notes.length),
    localizations.dialog_delete,
  )) {
    return false;
  }

  await ref.read(notesProvider.notifier).deleteAll(notes);

  return true;
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

  if (await askForConfirmation(
    localizations.dialog_permanently_delete,
    localizations.dialog_permanently_delete_body_single,
    localizations.dialog_permanently_delete,
    irreversible: true,
  )) {
    return false;
  }

  currentNoteNotifier.value = null;

  await ref.read(binProvider.notifier).permanentlyDelete(note);

  if (context.mounted && RouterRoute.isEditor) {
    context.pop();
  }

  return true;
}

/// Permanently deletes the [notes].
///
/// Returns `true` if the [notes] were permanently deleted, `false` otherwise.
///
/// First, asks for a confirmation if needed.
Future<bool> permanentlyDeleteNotes(WidgetRef ref, List<Note> notes) async {
  if (await askForConfirmation(
    localizations.dialog_permanently_delete,
    localizations.dialog_permanently_delete_body(notes.length),
    localizations.dialog_permanently_delete,
    irreversible: true,
  )) {
    return false;
  }

  await ref.read(binProvider.notifier).permanentlyDeleteAll(notes);

  return true;
}

/// Empties the bin by deleting every note inside.
///
/// First, asks for a confirmation if needed.
/// Exits the selection mode.
Future<bool> emptyBin(WidgetRef ref) async {
  if (await askForConfirmation(
    localizations.dialog_empty_bin,
    localizations.dialog_empty_bin_body,
    localizations.dialog_empty_bin,
    irreversible: true,
  )) {
    return false;
  }

  isSelectionModeNotifier.value = false;

  await ref.read(binProvider.notifier).empty();

  return true;
}
