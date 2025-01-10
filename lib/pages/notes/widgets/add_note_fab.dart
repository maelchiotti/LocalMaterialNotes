import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/actions/notes/add.dart';
import '../../../common/constants/constants.dart';
import '../../../models/note/note.dart';

/// Floating action button to add a note.
class AddNoteFab extends ConsumerStatefulWidget {
  /// Default constructor.
  const AddNoteFab({super.key});

  @override
  ConsumerState<AddNoteFab> createState() => _AddNoteFabState();
}

class _AddNoteFabState extends ConsumerState<AddNoteFab> {
  final fabKey = GlobalKey<ExpandableFabState>();

  void onPressed<NoteType>() {
    final fabState = fabKey.currentState;

    if (fabState == null) {
      return;
    }

    addNote<NoteType>(context, ref);
    if (fabState.isOpen) {
      fabState.toggle();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ExpandableFab(
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
        FloatingActionButton.extended(
          heroTag: '<add plain text note hero tag>',
          tooltip: l.tooltip_fab_add_note,
          onPressed: onPressed<PlainTextNote>,
          icon: const Icon(Icons.text_fields),
          label: Text('Plain text'),
        ),
        FloatingActionButton.extended(
          heroTag: '<add rich text note hero tag>',
          tooltip: l.tooltip_fab_add_note,
          onPressed: onPressed<RichTextNote>,
          icon: const Icon(Icons.format_paint),
          label: Text('Rich text'),
        ),
      ],
    );
  }
}
