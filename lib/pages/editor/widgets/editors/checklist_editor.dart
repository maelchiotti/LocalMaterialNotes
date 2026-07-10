import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_checklist/checklist.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../common/constants/constants.dart';
import '../../../../models/note/note.dart';
import '../../../../models/note/note_status.dart';
import '../../../../providers/notes/notes_provider.dart';
import '../../../../providers/notifiers/notifiers.dart';

/// Checklist editor.
class ChecklistEditor extends ConsumerStatefulWidget {
  /// Editor allowing to edit the checklist content of a [ChecklistNote].
  const ChecklistEditor({super.key, required this.note, required this.isNewNote, required this.readOnly});

  /// The note to display.
  final ChecklistNote note;

  /// Whether the note was just created.
  final bool isNewNote;

  /// Whether the text fields are read only.
  final bool readOnly;

  @override
  ConsumerState<ChecklistEditor> createState() => _ChecklistEditorState();
}

class _ChecklistEditorState extends ConsumerState<ChecklistEditor> {
  Timer? saveDebounce;
  List<ChecklistLine>? pendingChecklistLines;

  void onChanged(List<ChecklistLine> checklistLines) {
    pendingChecklistLines = checklistLines;

    // Reset the saving debounce timer on each change
    saveDebounce?.cancel();
    saveDebounce = Timer(const Duration(milliseconds: 1000), save);
  }

  void save([WidgetRef? widgetRef]) {
    if (pendingChecklistLines == null) {
      return;
    }

    final checkboxes = pendingChecklistLines!.map((checklistLine) => checklistLine.toggled).toList();
    final texts = pendingChecklistLines!.map((checklistLine) => checklistLine.text).toList();
    final newNote = widget.note
      ..checkboxes = checkboxes
      ..texts = texts;

    (widgetRef ?? ref)
        .read(notesProvider(status: NoteStatus.available, label: currentLabelFilter).notifier)
        .edit(newNote);
  }

  @override
  void dispose() {
    // If a save was waiting to happen, save immediately
    if (saveDebounce?.isActive ?? false) {
      saveDebounce!.cancel();
      save(globalRef);
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Checklist(
            lines: widget.note.checklistLines,
            enabled: !widget.readOnly,
            autofocusFirstLine: widget.isNewNote,
            textInputAction: TextInputAction.newline,
            textCapitalization: TextCapitalization.sentences,
            onChanged: (checklistLines) => onChanged(checklistLines),
          ),
        ),
      ],
    );
  }
}
