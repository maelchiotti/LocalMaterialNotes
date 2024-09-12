import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localmaterialnotes/common/actions/delete.dart';
import 'package:localmaterialnotes/common/actions/pin.dart';
import 'package:localmaterialnotes/common/actions/restore.dart';
import 'package:localmaterialnotes/common/actions/select.dart';
import 'package:localmaterialnotes/common/constants/constants.dart';
import 'package:localmaterialnotes/common/constants/paddings.dart';
import 'package:localmaterialnotes/common/constants/separators.dart';
import 'package:localmaterialnotes/common/extensions/build_context_extension.dart';
import 'package:localmaterialnotes/common/widgets/placeholders/error_placeholder.dart';
import 'package:localmaterialnotes/common/widgets/placeholders/loading_placeholder.dart';
import 'package:localmaterialnotes/models/note/note.dart';
import 'package:localmaterialnotes/providers/bin/bin_provider.dart';
import 'package:localmaterialnotes/providers/notes/notes_provider.dart';
import 'package:localmaterialnotes/routing/routes/routing_route.dart';

/// Selection mode's app bar.
///
/// Contains (sometimes depending on whether the current route is the notes list or the bin):
///   - A back button.
///   - The number of currently selected notes.
///   - A button to select or deselects all notes.
///   - A button to pin / restore the selected notes.
///   - A button to delete / permanently delete the selected notes.
class SelectionAppBar extends ConsumerStatefulWidget {
  /// Default constructor.
  const SelectionAppBar();

  @override
  ConsumerState<SelectionAppBar> createState() => _SelectionAppBarState();
}

class _SelectionAppBarState extends ConsumerState<SelectionAppBar> {
  /// Toggles the pin status of the [selectedNotes].
  Future<void> _togglePin(List<Note> selectedNotes) async {
    await togglePinNotes(context, ref, selectedNotes);

    if (!mounted) {
      return;
    }

    exitSelectionMode(context, ref);
  }

  /// Restores the [selectedNotes].
  Future<void> _restore(List<Note> selectedNotes) async {
    final restored = await restoreNotes(context, ref, selectedNotes);

    if (!restored || !mounted) {
      return;
    }

    exitSelectionMode(context, ref);
  }

  /// Deletes the [selectedNotes].
  Future<void> _delete(List<Note> selectedNotes) async {
    final deleted = await deleteNotes(context, ref, selectedNotes);

    if (!deleted || !mounted) {
      return;
    }

    exitSelectionMode(context, ref);
  }

  /// Permanently deletes the [selectedNotes].
  Future<void> _permanentlyDelete(List<Note> selectedNotes) async {
    final permanentlyDeleted = await permanentlyDeleteNotes(context, ref, selectedNotes);

    if (!permanentlyDeleted || !mounted) {
      return;
    }

    exitSelectionMode(context, ref);
  }

  /// Builds the app bar.
  ///
  /// The title and the behavior of the buttons can change depending on the difference between
  /// the length of the [selectedNotes] and the [totalNotesCount].
  AppBar _buildAppBar(List<Note> selectedNotes, int totalNotesCount) {
    final allSelected = selectedNotes.length == totalNotesCount;

    return AppBar(
      leading: BackButton(
        onPressed: () => exitSelectionMode(context, ref),
      ),
      title: Text('${selectedNotes.length}'),
      actions: [
        IconButton(
          icon: Icon(allSelected ? Icons.deselect : Icons.select_all),
          tooltip: allSelected ? localizations.tooltip_unselect_all : localizations.tooltip_select_all,
          onPressed: () => allSelected ? unselectAll(context, ref) : selectAll(context, ref),
        ),
        Padding(padding: Paddings.custom.appBarActionsEnd),
        Separator.divider1indent16.vertical,
        Padding(padding: Paddings.custom.appBarActionsEnd),
        if (context.route == RoutingRoute.bin) ...[
          IconButton(
            icon: const Icon(Icons.restore_from_trash),
            tooltip: localizations.tooltip_restore,
            onPressed: selectedNotes.isNotEmpty ? () => _restore(selectedNotes) : null,
          ),
          IconButton(
            icon: const Icon(Icons.delete_forever),
            tooltip: localizations.tooltip_permanently_delete,
            onPressed: selectedNotes.isNotEmpty ? () => _permanentlyDelete(selectedNotes) : null,
          ),
        ] else ...[
          IconButton(
            icon: const Icon(Icons.push_pin),
            tooltip: localizations.tooltip_toggle_pins,
            onPressed: selectedNotes.isNotEmpty ? () => _togglePin(selectedNotes) : null,
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            tooltip: localizations.tooltip_delete,
            onPressed: selectedNotes.isNotEmpty ? () => _delete(selectedNotes) : null,
          ),
        ],
        Padding(padding: Paddings.custom.appBarActionsEnd),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return context.route == RoutingRoute.notes
        ? ref.watch(notesProvider).when(
            data: (notes) {
              return _buildAppBar(notes.where((note) => note.selected).toList(), notes.length);
            },
            error: (error, stackTrace) {
              return const ErrorPlaceholder();
            },
            loading: () {
              return const LoadingPlaceholder();
            },
          )
        : ref.watch(binProvider).when(
            data: (notes) {
              return _buildAppBar(notes.where((note) => note.selected).toList(), notes.length);
            },
            error: (error, stackTrace) {
              return const ErrorPlaceholder();
            },
            loading: () {
              return const LoadingPlaceholder();
            },
          );
  }
}
