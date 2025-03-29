import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/label/label.dart';
import '../../../models/note/note.dart';
import '../../../models/note/note_status.dart';
import '../../../pages/editor/dialogs/labels_selection_dialog.dart';
import '../../../providers/labels/labels_list/labels_list_provider.dart';
import '../../../providers/notes/notes_provider.dart';
import '../../../providers/notifiers/notifiers.dart';
import '../../extensions/build_context_extension.dart';
import '../../ui/snack_bar_utils.dart';
import 'select.dart';

/// Asks the user to select the labels for the [note].
Future<List<Label>?> selectLabels(BuildContext context, WidgetRef ref, {required Note note}) async {
  if (ref.read(labelsListProvider).value == null || ref.read(labelsListProvider).value!.isEmpty) {
    SnackBarUtils().show(context, text: context.l.snack_bar_no_labels);

    return null;
  }

  // If the note is empty and thus not saved into the database, then forcefully save it to allow adding labels to it
  if (note.isEmpty) {
    await ref.read(notesProvider(status: NoteStatus.available, label: currentLabelFilter).notifier).edit(note);
  }

  if (!context.mounted) {
    return null;
  }

  final selectedLabels = await showAdaptiveDialog<List<Label>>(
    context: context,
    useRootNavigator: false,
    builder: (context) => LabelsSelectionDialog(note: note),
  );

  if (selectedLabels == null) {
    return null;
  }

  await ref
      .read(notesProvider(status: NoteStatus.available, label: currentLabelFilter).notifier)
      .editLabels(note, selectedLabels);

  currentNoteNotifier.value = note;

  return selectedLabels;
}

/// Asks the user to select the labels to add to the [notes].
Future<List<Label>?> addLabels(BuildContext context, WidgetRef ref, {required List<Note> notes}) async {
  if (ref.read(labelsListProvider).value == null || ref.read(labelsListProvider).value!.isEmpty) {
    SnackBarUtils().show(context, text: context.l.snack_bar_no_labels);

    return null;
  }

  final selectedLabels = await showAdaptiveDialog<List<Label>>(
    context: context,
    useRootNavigator: false,
    builder: (context) => LabelsSelectionDialog(),
  );

  if (selectedLabels == null) {
    return null;
  }

  await ref
      .read(notesProvider(status: NoteStatus.available, label: currentLabelFilter).notifier)
      .addLabels(notes, selectedLabels);

  if (context.mounted) {
    exitNotesSelectionMode(context, ref, notesStatus: NoteStatus.available);
  }

  return selectedLabels;
}
