import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/note/note.dart';
import '../../../providers/bin/bin_provider.dart';
import '../../../providers/notes/notes_provider.dart';
import '../../actions/notes/delete.dart';
import '../../actions/notes/pin.dart';
import '../../actions/notes/restore.dart';
import '../../actions/notes/select.dart';
import '../../actions/notes/share.dart';
import '../../constants/constants.dart';
import '../../constants/paddings.dart';
import '../../constants/separators.dart';
import '../../widgets/placeholders/error_placeholder.dart';
import '../../widgets/placeholders/loading_placeholder.dart';

/// Selection mode app bar.
class NotesSelectionAppBar extends ConsumerWidget {
  /// App bar shown when the notes are being selected, in the notes list or in the bin.
  const NotesSelectionAppBar({
    super.key,
    required this.notesPage,
  });

  /// Whether the current page is the notes list.
  final bool notesPage;

  /// Builds the app bar.
  ///
  /// The title and the behavior of the buttons can change depending on the difference between
  /// the length of the [selectedNotes] and the [totalNotesCount].
  AppBar buildAppBar(
    BuildContext context,
    WidgetRef ref,
    List<Note> selectedNotes,
    int totalNotesCount,
  ) {
    final allSelected = selectedNotes.length == totalNotesCount;

    return AppBar(
      leading: BackButton(
        onPressed: () => exitNotesSelectionMode(context, ref),
      ),
      title: Text('${selectedNotes.length}'),
      actions: [
        IconButton(
          icon: Icon(allSelected ? Icons.deselect : Icons.select_all),
          tooltip: allSelected ? l.tooltip_unselect_all : flutterL?.selectAllButtonLabel ?? 'Select all',
          onPressed: () => allSelected
              ? unselectAllNotes(context, ref, notesPage: notesPage)
              : selectAllNotes(context, ref, notesPage: notesPage),
        ),
        Padding(padding: Paddings.appBarActionsEnd),
        Separator.divider1indent16.vertical,
        Padding(padding: Paddings.appBarActionsEnd),
        if (notesPage) ...[
          IconButton(
            icon: const Icon(Icons.share),
            tooltip: 'Share',
            onPressed: selectedNotes.isNotEmpty ? () => shareNotes(selectedNotes) : null,
          ),
          IconButton(
            icon: const Icon(Icons.push_pin),
            tooltip: l.tooltip_toggle_pins,
            onPressed: selectedNotes.isNotEmpty ? () => togglePinNotes(context, ref, selectedNotes) : null,
          ),
          IconButton(
            icon: Icon(
              Icons.delete,
              color: selectedNotes.isNotEmpty ? Theme.of(context).colorScheme.error : null,
            ),
            tooltip: l.tooltip_delete,
            onPressed: selectedNotes.isNotEmpty ? () => deleteNotes(context, ref, selectedNotes) : null,
          ),
        ] else ...[
          IconButton(
            icon: const Icon(Icons.restore_from_trash),
            tooltip: l.tooltip_restore,
            onPressed: selectedNotes.isNotEmpty ? () => restoreNotes(context, ref, selectedNotes) : null,
          ),
          IconButton(
            icon: Icon(
              Icons.delete_forever,
              color: selectedNotes.isNotEmpty ? Theme.of(context).colorScheme.error : null,
            ),
            tooltip: l.tooltip_permanently_delete,
            onPressed: selectedNotes.isNotEmpty ? () => permanentlyDeleteNotes(context, ref, selectedNotes) : null,
          ),
        ],
        Padding(padding: Paddings.appBarActionsEnd),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) => notesPage
      ? ref.watch(notesProvider).when(
            data: (notes) => buildAppBar(
              context,
              ref,
              notes.where((note) => note.selected).toList(),
              notes.length,
            ),
            error: (exception, stackTrace) => ErrorPlaceholder(exception: exception, stackTrace: stackTrace),
            loading: () => const LoadingPlaceholder(),
          )
      : ref.watch(binProvider).when(
            data: (notes) => buildAppBar(
              context,
              ref,
              notes.where((note) => note.selected).toList(),
              notes.length,
            ),
            error: (exception, stackTrace) => ErrorPlaceholder(exception: exception, stackTrace: stackTrace),
            loading: () => const LoadingPlaceholder(),
          );
}
