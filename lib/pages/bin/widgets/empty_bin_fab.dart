import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/actions/notes/delete.dart';
import '../../../common/extensions/build_context_extension.dart';
import '../../../common/widgets/placeholders/empty_placeholder.dart';
import '../../../models/note/note_status.dart';
import '../../../providers/notes/notes_provider.dart';

/// Floating action button to empty the bin.
class EmptyBinFab extends ConsumerWidget {
  /// Default constructor.
  const EmptyBinFab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deletedNotesCount = ref.watch(notesProvider(status: NoteStatus.deleted)).value?.length;

    return deletedNotesCount != null && deletedNotesCount != 0
        ? FloatingActionButton(
            tooltip: context.l.tooltip_fab_empty_bin,
            onPressed: () => emptyBin(context, ref),
            child: const Icon(Icons.delete_forever),
          )
        : EmptyPlaceholder();
  }
}
