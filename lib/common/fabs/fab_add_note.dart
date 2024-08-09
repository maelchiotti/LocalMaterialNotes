import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localmaterialnotes/common/actions/add.dart';
import 'package:localmaterialnotes/utils/constants/constants.dart';

/// Floating action button to add a note.
class FabAddNote extends ConsumerStatefulWidget {
  const FabAddNote({super.key});

  @override
  ConsumerState<FabAddNote> createState() => _FabAddNoteState();
}

class _FabAddNoteState extends ConsumerState<FabAddNote> {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      tooltip: localizations.tooltip_fab_add_note,
      onPressed: () => addNote(context, ref),
      child: const Icon(Icons.add),
    );
  }
}
