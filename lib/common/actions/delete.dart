import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:localmaterialnotes/common/dialogs/confirmation_dialog.dart';
import 'package:localmaterialnotes/models/note/note.dart';
import 'package:localmaterialnotes/providers/bin/bin_provider.dart';
import 'package:localmaterialnotes/providers/current_note/current_note_provider.dart';
import 'package:localmaterialnotes/providers/notes/notes_provider.dart';
import 'package:localmaterialnotes/providers/notifiers.dart';
import 'package:localmaterialnotes/utils/constants/constants.dart';

Future<bool> deleteNote(BuildContext context, WidgetRef ref, Note? note) async {
  if (note == null) {
    return false;
  }

  if (await askForConfirmation(
    localizations.dialog_delete,
    localizations.dialog_delete_body_single,
    localizations.dialog_delete,
  )) {
    ref.read(currentNoteProvider.notifier).reset();
    await ref.read(notesProvider.notifier).delete(note);

    if (context.mounted && context.canPop()) {
      context.pop();
    }

    return true;
  }

  return false;
}

Future<void> deleteNotes(WidgetRef ref, List<Note> notes) async {
  if (await askForConfirmation(
    localizations.dialog_delete,
    localizations.dialog_delete_body(notes.length),
    localizations.dialog_delete,
  )) {
    await ref.read(notesProvider.notifier).deleteAll(notes);
  }
}

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
    ref.read(currentNoteProvider.notifier).reset();

    await ref.read(binProvider.notifier).permanentlyDelete(note);

    if (context.mounted && context.canPop()) {
      context.pop();
    }

    return true;
  }

  return false;
}

Future<void> permanentlyDeleteNotes(WidgetRef ref, List<Note> notes) async {
  if (await askForConfirmation(
    localizations.dialog_permanently_delete,
    localizations.dialog_permanently_delete_body(notes.length),
    localizations.dialog_permanently_delete,
    irreversible: true,
  )) {
    await ref.read(binProvider.notifier).permanentlyDeleteAll(notes);
  }
}

Future<void> emptyBin(WidgetRef ref) async {
  if (await askForConfirmation(
    localizations.dialog_empty_bin,
    localizations.dialog_empty_bin_body,
    localizations.dialog_empty_bin,
    irreversible: true,
  )) {
    isSelectionModeNotifier.value = false;

    await ref.read(binProvider.notifier).empty();
  }
}
