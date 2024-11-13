import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localmaterialnotes/common/actions/notes/delete.dart';
import 'package:localmaterialnotes/common/actions/notes/pin.dart';
import 'package:localmaterialnotes/common/actions/notes/restore.dart';
import 'package:localmaterialnotes/common/actions/notes/select.dart';
import 'package:localmaterialnotes/common/constants/constants.dart';
import 'package:localmaterialnotes/common/constants/paddings.dart';
import 'package:localmaterialnotes/common/constants/separators.dart';
import 'package:localmaterialnotes/common/extensions/build_context_extension.dart';
import 'package:localmaterialnotes/common/widgets/placeholders/error_placeholder.dart';
import 'package:localmaterialnotes/common/widgets/placeholders/loading_placeholder.dart';
import 'package:localmaterialnotes/models/note/note.dart';
import 'package:localmaterialnotes/providers/bin/bin_provider.dart';
import 'package:localmaterialnotes/providers/notes/notes/notes_provider.dart';
import 'package:localmaterialnotes/routing/routes/bin/bin_route.dart';
import 'package:localmaterialnotes/routing/routes/notes/notes_route.dart';
import 'package:localmaterialnotes/routing/routes/shell/shell_route.dart';

/// Notes selection mode app bar.
///
/// Contains (sometimes depending on whether the current route is the notes list or the bin):
///   - A back button.
///   - The number of currently selected notes.
///   - A button to select / unselects all notes.
///   - A button to toggle the pin status / restore the selected notes.
///   - A button to delete / permanently delete the selected notes.
class NotesSelectionAppBar extends ConsumerStatefulWidget {
  /// Default constructor.
  const NotesSelectionAppBar({super.key});

  @override
  ConsumerState<NotesSelectionAppBar> createState() => _SelectionAppBarState();
}

class _SelectionAppBarState extends ConsumerState<NotesSelectionAppBar> {
  /// Builds the app bar.
  ///
  /// The title and the behavior of the buttons can change depending on the difference between
  /// the length of the [selectedNotes] and the [totalNotesCount].
  AppBar buildAppBar(List<Note> selectedNotes, int totalNotesCount) {
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
          onPressed: () => allSelected ? unselectAllNotes(context, ref) : selectAllNotes(context, ref),
        ),
        Padding(padding: Paddings.appBarActionsEnd),
        Separator.divider1indent16.vertical,
        Padding(padding: Paddings.appBarActionsEnd),
        if (context.location == BinRoute().location) ...[
          IconButton(
            icon: const Icon(Icons.restore_from_trash),
            tooltip: l.tooltip_restore,
            onPressed: selectedNotes.isNotEmpty ? () => restoreNotes(context, ref, selectedNotes) : null,
          ),
          IconButton(
            icon: const Icon(Icons.delete_forever),
            tooltip: l.tooltip_permanently_delete,
            onPressed: selectedNotes.isNotEmpty ? () => permanentlyDeleteNotes(context, ref, selectedNotes) : null,
          ),
        ] else ...[
          IconButton(
            icon: const Icon(Icons.push_pin),
            tooltip: l.tooltip_toggle_pins,
            onPressed: selectedNotes.isNotEmpty ? () => togglePinNotes(context, ref, selectedNotes) : null,
          ),
          IconButton(
            icon: Icon(
              Icons.delete,
              color: Theme.of(context).colorScheme.error,
            ),
            tooltip: l.tooltip_delete,
            onPressed: selectedNotes.isNotEmpty ? () => deleteNotes(context, ref, selectedNotes) : null,
          ),
        ],
        Padding(padding: Paddings.appBarActionsEnd),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return context.location == NotesRoute().location
        ? ref.watch(notesProvider).when(
            data: (notes) {
              return buildAppBar(notes.where((note) => note.selected).toList(), notes.length);
            },
            error: (exception, stackTrace) {
              return ErrorPlaceholder(exception: exception, stackTrace: stackTrace);
            },
            loading: () {
              return const LoadingPlaceholder();
            },
          )
        : ref.watch(binProvider).when(
            data: (notes) {
              return buildAppBar(notes.where((note) => note.selected).toList(), notes.length);
            },
            error: (exception, stackTrace) {
              return ErrorPlaceholder(exception: exception, stackTrace: stackTrace);
            },
            loading: () {
              return const LoadingPlaceholder();
            },
          );
  }
}
