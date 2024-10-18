import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localmaterialnotes/common/actions/add.dart';
import 'package:localmaterialnotes/common/constants/constants.dart';

/// Floating action button to add a note.
class FabAddNote extends ConsumerWidget {
  /// Default constructor.
  const FabAddNote({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FloatingActionButton(
      tooltip: l.tooltip_fab_add_note,
      onPressed: () => addNote(context, ref),
      child: const Icon(Icons.add),
    );
  }
}
