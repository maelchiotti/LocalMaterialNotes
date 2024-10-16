import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:localmaterialnotes/common/constants/constants.dart';
import 'package:localmaterialnotes/common/extensions/build_context_extension.dart';
import 'package:localmaterialnotes/common/widgets/dialogs/confirmation_dialog.dart';
import 'package:localmaterialnotes/models/note/note.dart';
import 'package:localmaterialnotes/providers/bin/bin_provider.dart';
import 'package:localmaterialnotes/providers/notifiers.dart';
import 'package:localmaterialnotes/routing/routes/routing_route.dart';

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
    localizations.dialog_restore,
    localizations.dialog_restore_body(1),
    localizations.dialog_restore,
  )) {
    return false;
  }

  currentNoteNotifier.value = null;

  await ref.read(binProvider.notifier).restore(note);

  if (context.mounted && context.route == RoutingRoute.notesEditor) {
    context.pop();
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
    localizations.dialog_restore,
    localizations.dialog_restore_body(notes.length),
    localizations.dialog_restore,
  )) {
    return false;
  }

  await ref.read(binProvider.notifier).restoreAll(notes);

  return true;
}
