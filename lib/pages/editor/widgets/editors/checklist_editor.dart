import 'package:flutter/material.dart';
import 'package:flutter_checklist/checklist.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../models/note/note.dart';
import '../../../../models/note/note_status.dart';
import '../../../../providers/notes/notes_provider.dart';
import '../../../../providers/notifiers/notifiers.dart';

/// Checklist editor.
class ChecklistEditor extends ConsumerWidget {
  /// Editor allowing to edit the checklist content of a [ChecklistNote].
  const ChecklistEditor({super.key, required this.note, required this.isNewNote, required this.readOnly});

  /// The note to display.
  final ChecklistNote note;

  /// Whether the note was just created.
  final bool isNewNote;

  /// Whether the text fields are read only.
  final bool readOnly;

  /// Called when an item of the checklist changes with the new [checklistLines].
  void onChecklistChanged(WidgetRef ref, List<ChecklistLine> checklistLines) {
    ChecklistNote newNote = note
      ..checkboxes = checklistLines.map((checklistLine) => checklistLine.toggled).toList()
      ..texts = checklistLines.map((checklistLine) => checklistLine.text).toList();

    ref.read(notesProvider(status: NoteStatus.available, label: currentLabelFilter).notifier).edit(newNote);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Expanded(
          child: Checklist(
            lines: note.checklistLines,
            enabled: !readOnly,
            autofocusFirstLine: isNewNote,
            onChanged: (checklistLines) => onChecklistChanged(ref, checklistLines),
          ),
        ),
      ],
    );
  }
}
