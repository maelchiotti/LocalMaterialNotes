import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/actions/notes/add.dart';
import '../../../common/constants/constants.dart';
import '../../../models/note/note.dart';
import '../../../models/note/notes_types.dart';
import '../../../providers/preferences/preferences_provider.dart';

/// Floating action button to add a note.
class AddNoteFab extends ConsumerStatefulWidget {
  /// Default constructor.
  const AddNoteFab({super.key});

  @override
  ConsumerState<AddNoteFab> createState() => _AddNoteFabState();
}

class _AddNoteFabState extends ConsumerState<AddNoteFab> {
  final fabKey = GlobalKey<ExpandableFabState>();

  void onFocusChange(bool hasFocus) {
    if (!hasFocus) {
      final fabState = fabKey.currentState;

      if (fabState == null) {
        return;
      }

      if (fabState.isOpen) {
        fabState.toggle();
      }
    }
  }

  void onPressed<NoteType>() {
    addNote<NoteType>(context, ref);

    if (fabKey.currentState != null && fabKey.currentState!.isOpen) {
      fabKey.currentState!.toggle();
    }
  }

  @override
  Widget build(BuildContext context) {
    final availableNotesTypes = ref.watch(
      preferencesProvider.select((preferences) => preferences.availableNotesTypes),
    );

    return availableNotesTypes.length == 1
        ? FloatingActionButton(
            tooltip: l.tooltip_fab_add_note,
            onPressed: switch (availableNotesTypes.first) {
              NoteType.plainText => onPressed<PlainTextNote>,
              NoteType.richText => onPressed<RichTextNote>,
            },
            child: const Icon(Icons.add),
          )
        : Focus(
            onFocusChange: onFocusChange,
            child: ExpandableFab(
              key: fabKey,
              type: ExpandableFabType.up,
              childrenAnimation: ExpandableFabAnimation.none,
              distance: 75,
              openButtonBuilder: RotateFloatingActionButtonBuilder(
                heroTag: '<open add note FAB hero tag>',
                child: const Icon(Icons.add),
              ),
              closeButtonBuilder: RotateFloatingActionButtonBuilder(
                heroTag: '<close add note FAB hero tag>',
                child: const Icon(Icons.close),
              ),
              children: [
                if (availableNotesTypes.contains(NoteType.plainText))
                  FloatingActionButton.extended(
                    heroTag: '<add plain text note hero tag>',
                    tooltip: l.tooltip_fab_add_plain_text_note,
                    onPressed: onPressed<PlainTextNote>,
                    icon: Icon(NoteType.plainText.icon),
                    label: Text(NoteType.plainText.title),
                  ),
                if (availableNotesTypes.contains(NoteType.richText))
                  FloatingActionButton.extended(
                    heroTag: '<add rich text note hero tag>',
                    tooltip: l.tooltip_fab_add_rich_text_note,
                    onPressed: onPressed<RichTextNote>,
                    icon: Icon(NoteType.richText.icon),
                    label: Text(NoteType.richText.title),
                  ),
              ],
            ),
          );
  }
}
