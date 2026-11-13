import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/actions/notes/add.dart';
import '../../../common/actions/notes/pop.dart';
import '../../../common/constants/constants.dart';
import '../../../common/extensions/build_context_extension.dart';
import '../../../models/label/label.dart';
import '../../../models/note/types/note_type.dart';
import '../../../providers/notifiers/notifiers.dart';

/// Floating action button to add a note.
class AddNoteFab extends ConsumerStatefulWidget {
  /// Default constructor.
  const AddNoteFab({super.key, required this.label});

  /// The current label.
  final Label? label;

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

  /// Builds the button that opens or closes the FAB, rotated according to the [progress] of the animation.
  ///
  /// It replaces the `RotateFloatingActionButtonBuilder` of the package, whose buttons are built with
  /// `autofocus: true`: when the FAB finishes closing, its button is built again and takes the focus,
  /// which removes it from the editor that was opened in the meantime and closes the keyboard.
  FloatingActionButtonBuilder buildToggleButton({required String heroTag, required IconData icon}) {
    return FloatingActionButtonBuilder(
      // Size of a regular floating action button
      size: 56,
      builder: (context, onPressed, progress) {
        return AnimatedBuilder(
          animation: progress,
          builder: (context, _) {
            return Transform.rotate(
              angle: progress.value * math.pi / 2,
              child: FloatingActionButton(heroTag: heroTag, onPressed: onPressed, child: Icon(icon)),
            );
          },
        );
      },
    );
  }

  void onPressed(NoteType noteType) {
    closeAddNoteFabIfOpen();

    addNote(context, ref, noteType: noteType);
  }

  @override
  Widget build(BuildContext context) {
    final availableNotesTypes = NoteType.available;

    return availableNotesTypes.length == 1
        ? FloatingActionButton(
            tooltip: context.l.tooltip_fab_add_note,
            onPressed: () => onPressed(availableNotesTypes.first),
            child: const Icon(Icons.add),
          )
        : ExpandableFab(
            key: widget.label == null ? addNoteFabKey : labeledAddNoteFabKey,
            type: ExpandableFabType.up,
            childrenAnimation: ExpandableFabAnimation.none,
            distance: 64,
            openButtonBuilder: buildToggleButton(heroTag: '<open add note FAB hero tag>', icon: Icons.add),
            closeButtonBuilder: buildToggleButton(heroTag: '<close add note FAB hero tag>', icon: Icons.close),
            afterOpen: onOpen,
            afterClose: onClose,
            children: [
              if (availableNotesTypes.contains(NoteType.plainText))
                FloatingActionButton.extended(
                  heroTag: '<add plain text note hero tag>',
                  tooltip: context.l.tooltip_fab_add_plain_text_note,
                  onPressed: () => onPressed(NoteType.plainText),
                  icon: Icon(NoteType.plainText.icon),
                  label: Text(NoteType.plainText.title(context)),
                ),
              if (availableNotesTypes.contains(NoteType.markdown))
                FloatingActionButton.extended(
                  heroTag: '<add markdown note hero tag>',
                  tooltip: context.l.tooltip_fab_add_markdown_note,
                  onPressed: () => onPressed(NoteType.markdown),
                  icon: Icon(NoteType.markdown.icon),
                  label: Text(NoteType.markdown.title(context)),
                ),
              if (availableNotesTypes.contains(NoteType.richText))
                FloatingActionButton.extended(
                  heroTag: '<add rich text note hero tag>',
                  tooltip: context.l.tooltip_fab_add_rich_text_note,
                  onPressed: () => onPressed(NoteType.richText),
                  icon: Icon(NoteType.richText.icon),
                  label: Text(NoteType.richText.title(context)),
                ),
              if (availableNotesTypes.contains(NoteType.checklist))
                FloatingActionButton.extended(
                  heroTag: '<add checklist note hero tag>',
                  tooltip: context.l.tooltip_fab_add_checklist_note,
                  onPressed: () => onPressed(NoteType.checklist),
                  icon: Icon(NoteType.checklist.icon),
                  label: Text(NoteType.checklist.title(context)),
                ),
            ],
          );
  }
}
