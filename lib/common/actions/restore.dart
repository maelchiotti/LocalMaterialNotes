import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:localmaterialnotes/common/dialogs/confirmation_dialog.dart';
import 'package:localmaterialnotes/models/note/note.dart';
import 'package:localmaterialnotes/providers/bin/bin_provider.dart';
import 'package:localmaterialnotes/providers/notifiers.dart';
import 'package:localmaterialnotes/utils/constants/constants.dart';

Future<bool> restoreNote(BuildContext context, WidgetRef ref, Note? note) async {
  if (note == null) {
    return false;
  }

  if (await askForConfirmation(
    localizations.dialog_restore,
    localizations.dialog_restore_body_single,
    localizations.dialog_restore,
  )) {
    currentNoteNotifier.value = null;

    await ref.read(binProvider.notifier).restore(note);

    if (context.mounted && context.canPop()) {
      context.pop();
    }

    return true;
  }

  return false;
}

Future<void> restoreNotes(WidgetRef ref, List<Note> notes) async {
  if (await askForConfirmation(
    localizations.dialog_restore,
    localizations.dialog_restore_body(notes.length),
    localizations.dialog_restore,
  )) {
    await ref.read(binProvider.notifier).restoreAll(notes);
  }
}
