import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/note/note.dart';
import '../../../models/note/note_status.dart';
import '../../../providers/notes/notes_provider.dart';
import '../../../providers/notifiers/notifiers.dart';
import '../../constants/constants.dart';
import '../../dialogs/confirmation_dialog.dart';
import '../../extensions/build_context_extension.dart';
import '../../ui/snack_bar_utils.dart';
import 'archive.dart';
import 'select.dart';

/// Unarchives the [note].
///
/// Returns `true` if the [note] was unarchived, `false` otherwise.
Future<bool> unarchiveNote(
  BuildContext context,
  WidgetRef ref, {
  required Note note,
  bool pop = false,
  bool cancel = true,
}) async {
  if (!await askForConfirmation(
    context,
    context.l.dialog_unarchive,
    context.l.dialog_unarchive_body(1),
    context.l.dialog_unarchive,
  )) {
    return false;
  }

  if (context.mounted && pop) {
    // Use the root navigator key to avoid popping to the lock screen
    Navigator.pop(rootNavigatorKey.currentContext!);
  }

  currentNoteNotifier.value = null;

  final succeeded = await ref
      .read(notesProvider(status: NoteStatus.archived, label: currentLabelFilter).notifier)
      .setArchived([note], false);

  if (succeeded && cancel && context.mounted) {
    SnackBarUtils().show(
      context,
      text: context.l.snack_bar_unarchived(1),
      onCancel: (globalRef) async => await archiveNote(context, globalRef, note: note, cancel: false),
    );
  }

  return succeeded;
}

/// Unarchives the [notes].
///
/// Returns `true` if the [notes] were unarchived, `false` otherwise.
Future<bool> unarchiveNotes(
  BuildContext context,
  WidgetRef ref, {
  required List<Note> notes,
  bool cancel = true,
}) async {
  if (!await askForConfirmation(
    context,
    context.l.dialog_unarchive,
    context.l.dialog_unarchive_body(notes.length),
    context.l.dialog_unarchive,
  )) {
    return false;
  }

  final succeeded = await ref
      .read(notesProvider(status: NoteStatus.archived, label: currentLabelFilter).notifier)
      .setArchived(notes, false);

  if (context.mounted) {
    exitNotesSelectionMode(context, ref, notesStatus: NoteStatus.archived);
  }

  if (succeeded && cancel && context.mounted) {
    SnackBarUtils().show(
      context,
      text: context.l.snack_bar_unarchived(notes.length),
      onCancel: (globalRef) async => await archiveNotes(context, globalRef, notes: notes, cancel: false),
    );
  }

  return succeeded;
}
