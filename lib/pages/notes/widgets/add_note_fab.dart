import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/actions/notes/add.dart';
import '../../../common/actions/notes/pop.dart';
import '../../../common/constants/constants.dart';
import '../../../models/note/types/note_type.dart';
import '../../../providers/notifiers/notifiers.dart';

/// Floating action button to add a note.
class AddNoteFab extends ConsumerStatefulWidget {
  /// Default constructor.
  const AddNoteFab({super.key});

  @override
  ConsumerState<AddNoteFab> createState() => _AddNoteFabState();
}

class _AddNoteFabState extends ConsumerState<AddNoteFab> {
  void onOpen() {
    canPopNotifier.update();
  }

  void onClose() {
    canPopNotifier.update();
  }

  void onPressed(NoteType noteType) {
    addNote(context, ref, noteType: noteType);

    closeAddNoteFabIfOpen();
  }

  @override
  Widget build(BuildContext context) {
    final availableNotesTypes = NoteType.available;

    return availableNotesTypes.length == 1
        ? FloatingActionButton(
          tooltip: l.tooltip_fab_add_note,
          onPressed: () => onPressed(availableNotesTypes.first),
          child: const Icon(Icons.add),
        )
        : ExpandableFab(
          key: addNoteFabKey,
          type: ExpandableFabType.up,
          childrenAnimation: ExpandableFabAnimation.none,
          distance: 64,
          openButtonBuilder: RotateFloatingActionButtonBuilder(
            heroTag: '<open add note FAB hero tag>',
            child: const Icon(Icons.add),
          ),
          closeButtonBuilder: RotateFloatingActionButtonBuilder(
            heroTag: '<close add note FAB hero tag>',
            child: const Icon(Icons.close),
          ),
          afterOpen: onOpen,
          afterClose: onClose,
          children: [
            if (availableNotesTypes.contains(NoteType.plainText))
              FloatingActionButton.extended(
                heroTag: '<add plain text note hero tag>',
                tooltip: l.tooltip_fab_add_plain_text_note,
                onPressed: () => onPressed(NoteType.plainText),
                icon: Icon(NoteType.plainText.icon),
                label: Text(NoteType.plainText.title),
              ),
            if (availableNotesTypes.contains(NoteType.markdown))
              FloatingActionButton.extended(
                heroTag: '<add markdown note hero tag>',
                tooltip: l.tooltip_fab_add_markdown_note,
                onPressed: () => onPressed(NoteType.markdown),
                icon: Icon(NoteType.markdown.icon),
                label: Text(NoteType.markdown.title),
              ),
            if (availableNotesTypes.contains(NoteType.richText))
              FloatingActionButton.extended(
                heroTag: '<add rich text note hero tag>',
                tooltip: l.tooltip_fab_add_rich_text_note,
                onPressed: () => onPressed(NoteType.richText),
                icon: Icon(NoteType.richText.icon),
                label: Text(NoteType.richText.title),
              ),
            if (availableNotesTypes.contains(NoteType.checklist))
              FloatingActionButton.extended(
                heroTag: '<add checklist note hero tag>',
                tooltip: l.tooltip_fab_add_checklist_note,
                onPressed: () => onPressed(NoteType.checklist),
                icon: Icon(NoteType.checklist.icon),
                label: Text(NoteType.checklist.title),
              ),
          ],
        );
  }
}
