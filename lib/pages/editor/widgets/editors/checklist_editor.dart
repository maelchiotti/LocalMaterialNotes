import 'package:flutter/material.dart';
import 'package:flutter_checklist/checklist.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../models/note/note.dart';

/// Checklist editor.
class ChecklistEditor extends ConsumerStatefulWidget {
  /// Editor allowing to edit the checklist content of a [ChecklistNote].
  const ChecklistEditor({
    super.key,
    required this.note,
    required this.isNewNote,
    required this.readOnly,
    required this.onChanged,
  });

  /// The note to display.
  final ChecklistNote note;

  /// Whether the note was just created.
  final bool isNewNote;

  /// Whether the text fields are read only.
  final bool readOnly;

  /// Called when the note has changed.
  final ValueChanged<Note> onChanged;

  @override
  ConsumerState<ChecklistEditor> createState() => _ChecklistEditorState();
}

class _ChecklistEditorState extends ConsumerState<ChecklistEditor> {
  void onChanged(List<ChecklistLine> checklistLines) {
    final checkboxes = checklistLines.map((checklistLine) => checklistLine.toggled).toList();
    final texts = checklistLines.map((checklistLine) => checklistLine.text).toList();
    final note = widget.note
      ..checkboxes = checkboxes
      ..texts = texts;

    widget.onChanged(note);
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
