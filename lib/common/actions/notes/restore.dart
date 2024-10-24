import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:localmaterialnotes/common/actions/notes/select.dart';
import 'package:localmaterialnotes/common/constants/constants.dart';
import 'package:localmaterialnotes/common/dialogs/confirmation_dialog.dart';
import 'package:localmaterialnotes/common/extensions/build_context_extension.dart';
import 'package:localmaterialnotes/models/note/note.dart';
import 'package:localmaterialnotes/providers/bin/bin_provider.dart';
import 'package:localmaterialnotes/providers/notifiers.dart';
import 'package:localmaterialnotes/routing/routes/notes/notes_editor_route.dart';
import 'package:localmaterialnotes/routing/routes/shell/shell_route.dart';

/// Restores the [note].
///
/// Returns `true` if the [note] was restored, `false` otherwise.
///
/// First, asks for a confirmation if needed.
/// Finally, pops the route if the note was restored from the editor page.
Future<bool> restoreNote(BuildContext context, WidgetRef ref, Note? note) async {
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

  currentNoteNotifier.value = null;

  final succeeded = await ref.read(binProvider.notifier).restore(note);

  if (context.mounted && context.location == const NotesEditorRoute.empty().location) {
    context.pop();
  }

  return succeeded;
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
