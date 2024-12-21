import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../constants/constants.dart';
import '../../../models/label/label.dart';
import '../../../models/note/note.dart';
import '../../../pages/editor/dialogs/labels_selection_dialog.dart';
import '../../../providers/labels/labels_list/labels_list_provider.dart';
import '../../../providers/notes/notes_provider.dart';
import '../../../providers/notifiers/notifiers.dart';
import '../../../utils/snack_bar_utils.dart';

/// Asks the user to select the labels for the [note].
Future<List<Label>?> selectLabels(BuildContext context, WidgetRef ref, Note note) async {
  if (ref.read(labelsListProvider).value == null || ref.read(labelsListProvider).value!.isEmpty) {
    SnackBarUtils.info(l.snack_bar_no_labels).show();

    return null;
  }

  final selectedLabels = await showAdaptiveDialog<List<Label>>(
    context: context,
    useRootNavigator: false,
    builder: (context) => LabelsSelectionDialog(
      note: note,
    ),
  );

  if (selectedLabels == null) {
    return null;
  }

  await ref.read(notesProvider.notifier).editLabels(note, selectedLabels);

  // Forcefully notify the listeners because only the labels of the note have changed
  currentNoteNotifier.value = note;
  currentNoteNotifier.forceNotify();

  return selectedLabels;
}
