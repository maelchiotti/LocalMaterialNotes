import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/note/note.dart';
import '../../../providers/notes/notes_provider.dart';
import '../../../providers/notifiers/notifiers.dart';
import '../../constants/constants.dart';
import '../../dialogs/confirmation_dialog.dart';
import '../../extensions/build_context_extension.dart';
import '../../ui/snack_bar_utils.dart';
import 'select.dart';
import 'unarchive.dart';

/// Archives the [note].
///
/// Returns `true` if the [note] was archived, `false` otherwise.
Future<bool> archiveNote(
  BuildContext context,
  WidgetRef ref, {
  required Note note,
  bool pop = false,
  bool cancel = true,
}) async {
  if (!await askForConfirmation(
    context,
    context.l.dialog_archive,
    context.l.dialog_archive_body(1),
    context.l.dialog_archive,
  )) {
    return false;
  }

  if (context.mounted && pop) {
    // Use the root navigator key to avoid popping to the lock screen
    Navigator.pop(rootNavigatorKey.currentContext!);
  }

  currentNoteNotifier.value = null;

  final succeeded = await ref.read(notesProvider(status: note.status, label: currentLabelFilter).notifier).setArchived([
    note,
  ], true);

  if (succeeded && cancel && context.mounted) {
    SnackBarUtils().show(
      context,
      text: context.l.snack_bar_archived(1),
      onCancel: (globalRef) async =>
          await unarchiveNote(rootNavigatorKey.currentContext!, globalRef, note: note, cancel: false),
    );
  }

  return succeeded;
}

/// Archives the [notes].
///
/// Returns `true` if the [notes] were archived, `false` otherwise.
Future<bool> archiveNotes(BuildContext context, WidgetRef ref, {required List<Note> notes, bool cancel = true}) async {
  if (!await askForConfirmation(
    context,
    context.l.dialog_archive,
    context.l.dialog_archive_body(notes.length),
    context.l.dialog_archive,
  )) {
    return false;
  }

  final succeeded = await ref
      .read(notesProvider(status: notes.first.status, label: currentLabelFilter).notifier)
      .setArchived(notes, true);

  if (context.mounted) {
    exitNotesSelectionMode(context, ref, notesStatus: notes.first.status);
  }

  if (succeeded && cancel && context.mounted) {
    SnackBarUtils().show(
      context,
      text: context.l.snack_bar_archived(notes.length),
      onCancel: (globalRef) async =>
          await unarchiveNotes(rootNavigatorKey.currentContext!, globalRef, notes: notes, cancel: false),
    );
  }

  return succeeded;
}
