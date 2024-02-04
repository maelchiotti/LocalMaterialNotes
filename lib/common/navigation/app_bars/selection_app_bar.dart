import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localmaterialnotes/common/actions/delete.dart';
import 'package:localmaterialnotes/common/actions/pin.dart';
import 'package:localmaterialnotes/common/actions/restore.dart';
import 'package:localmaterialnotes/common/actions/select.dart';
import 'package:localmaterialnotes/common/placeholders/empty_placeholder.dart';
import 'package:localmaterialnotes/common/placeholders/error_placeholder.dart';
import 'package:localmaterialnotes/common/placeholders/loading_placeholder.dart';
import 'package:localmaterialnotes/common/routing/router_route.dart';
import 'package:localmaterialnotes/models/note/note.dart';
import 'package:localmaterialnotes/providers/bin/bin_provider.dart';
import 'package:localmaterialnotes/providers/notes/notes_provider.dart';
import 'package:localmaterialnotes/utils/constants/constants.dart';
import 'package:localmaterialnotes/utils/constants/paddings.dart';
import 'package:localmaterialnotes/utils/constants/separators.dart';

class SelectionAppBar extends ConsumerStatefulWidget {
  const SelectionAppBar();

  @override
  ConsumerState<SelectionAppBar> createState() => _SelectionAppBarState();
}

class _SelectionAppBarState extends ConsumerState<SelectionAppBar> {
  Future<void> _togglePin(List<Note> selectedNotes) async {
    await togglePinNotes(context, ref, selectedNotes);
    exitSelectionMode(ref);
  }

  Future<void> _restore(List<Note> selectedNotes) async {
    await restoreNotes(context, ref, selectedNotes);
    exitSelectionMode(ref);
  }

  Future<void> _delete(List<Note> selectedNotes) async {
    await deleteNotes(context, ref, selectedNotes);
    exitSelectionMode(ref);
  }

  Future<void> _permanentlyDelete(List<Note> selectedNotes) async {
    await permanentlyDeleteNotes(context, ref, selectedNotes);
    exitSelectionMode(ref);
  }

  AppBar _buildAppBar(List<Note> selectedNotes, int totalNotesCount) {
    final allSelected = selectedNotes.length == totalNotesCount;

    return AppBar(
      leading: BackButton(
        onPressed: () => exitSelectionMode(ref),
      ),
      title: Text('${selectedNotes.length}'),
      actions: [
        IconButton(
          icon: Icon(allSelected ? Icons.deselect : Icons.select_all),
          tooltip: allSelected ? localizations.tooltip_unselect_all : localizations.tooltip_select_all,
          onPressed: () => allSelected ? unselectAll(ref) : selectAll(ref),
        ),
        Padding(padding: Paddings.custom.appBarActionsEnd),
        Separator.divider1indent16.vertical,
        Padding(padding: Paddings.custom.appBarActionsEnd),
        if (RouterRoute.isBin) ...[
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
    return RouterRoute.isBin
        ? ref.watch(binProvider).when(
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
        : ref.watch(notesProvider).when(
            data: (notes) {
              return _buildAppBar(notes.where((note) => note.selected).toList(), notes.length);
            },
            error: (error, stackTrace) {
              return const EmptyPlaceholder();
            },
            loading: () {
              return const EmptyPlaceholder();
            },
          );
  }
}
