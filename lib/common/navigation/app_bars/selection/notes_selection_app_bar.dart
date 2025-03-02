import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../models/note/note.dart';
import '../../../../models/note/note_status.dart';
import '../../../../providers/notes/notes_provider.dart';
import '../../../../providers/notifiers/notifiers.dart';
import '../../../actions/notes/archive.dart';
import '../../../actions/notes/copy.dart';
import '../../../actions/notes/delete.dart';
import '../../../actions/notes/labels.dart';
import '../../../actions/notes/lock.dart';
import '../../../actions/notes/pin.dart';
import '../../../actions/notes/restore.dart';
import '../../../actions/notes/select.dart';
import '../../../actions/notes/share.dart';
import '../../../actions/notes/unarchive.dart';
import '../../../constants/constants.dart';
import '../../../constants/paddings.dart';
import '../../../constants/separators.dart';
import '../../../preferences/preference_key.dart';
import '../../../widgets/placeholders/error_placeholder.dart';
import '../../../widgets/placeholders/loading_placeholder.dart';
import '../../enums/notes/selection_archived_menu_option.dart';
import '../../enums/notes/selection_available_menu_option.dart';
import '../../enums/notes/selection_deleted_menu_option.dart';

/// Selection mode app bar.
class NotesSelectionAppBar extends ConsumerWidget {
  /// App bar shown when the notes are being selected, in the notes list or in the bin.
  const NotesSelectionAppBar({
    super.key,
    required this.notesStatus,
  });

  /// The status of the notes in the page.
  final NoteStatus notesStatus;

  /// Action to perform on the available [notes] depending on the selected [menuOption].
  Future<void> onAvailableMenuOptionSelected(
    BuildContext context,
    WidgetRef ref,
    List<Note> notes,
    SelectionAvailableMenuOption menuOption,
  ) async {
    switch (menuOption) {
      case SelectionAvailableMenuOption.copy:
        await copyNotes(notes: notes);
      case SelectionAvailableMenuOption.share:
        await shareNotes(notes: notes);
      case SelectionAvailableMenuOption.togglePin:
        await togglePinNotes(context, ref, notes: notes);
      case SelectionAvailableMenuOption.toggleLock:
        await toggleLockNotes(context, ref, notes: notes);
      case SelectionAvailableMenuOption.addLabels:
        await addLabels(context, ref, notes: notes);
      case SelectionAvailableMenuOption.archive:
        await archiveNotes(context, ref, notes: notes);
      case SelectionAvailableMenuOption.delete:
        await deleteNotes(context, ref, notes: notes);
    }
  }

  /// Action to perform on the archived [notes] depending on the selected [menuOption].
  Future<void> onArchivedMenuOptionSelected(
    BuildContext context,
    WidgetRef ref,
    List<Note> notes,
    SelectionArchivedMenuOption menuOption,
  ) async {
    switch (menuOption) {
      case SelectionArchivedMenuOption.copy:
        await copyNotes(notes: notes);
      case SelectionArchivedMenuOption.share:
        await shareNotes(notes: notes);
      case SelectionArchivedMenuOption.unarchive:
        await unarchiveNotes(context, ref, notes: notes);
    }
  }

  /// Action to perform on the deleted [notes] depending on the selected [menuOption].
  Future<void> onDeletedMenuOptionSelected(
    BuildContext context,
    WidgetRef ref,
    List<Note> notes,
    SelectionDeletedMenuOption menuOption,
  ) async {
    switch (menuOption) {
      case SelectionDeletedMenuOption.restore:
        await restoreNotes(context, ref, notes: notes);
      case SelectionDeletedMenuOption.deletePermanently:
        await permanentlyDeleteNotes(context, ref, notes: notes);
    }
  }

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
    final enableLabels = PreferenceKey.enableLabels.preferenceOrDefault;
    final lockNote = PreferenceKey.lockNote.preferenceOrDefault;

    final allSelected = selectedNotes.length == totalNotesCount;

    return AppBar(
      leading: BackButton(
        onPressed: () => exitNotesSelectionMode(context, ref, notesStatus: notesStatus),
      ),
      title: Text('${selectedNotes.length}'),
      actions: [
        IconButton(
          icon: Icon(allSelected ? Icons.deselect : Icons.select_all),
          tooltip: allSelected ? l.tooltip_unselect_all : fl?.selectAllButtonLabel ?? 'Select all',
          onPressed: () => allSelected
              ? unselectAllNotes(context, ref, notesStatus: notesStatus)
              : selectAllNotes(context, ref, notesStatus: notesStatus),
        ),
        Padding(
          padding: Paddings.appBarSeparator,
          child: Separator.divider1indent16.vertical,
        ),
        if (notesStatus == NoteStatus.available)
          PopupMenuButton<SelectionAvailableMenuOption>(
            itemBuilder: (context) => ([
              SelectionAvailableMenuOption.copy.popupMenuItem(context),
              SelectionAvailableMenuOption.share.popupMenuItem(context),
              const PopupMenuDivider(),
              SelectionAvailableMenuOption.togglePin.popupMenuItem(context),
              if (lockNote) SelectionAvailableMenuOption.toggleLock.popupMenuItem(context),
              if (enableLabels) SelectionAvailableMenuOption.addLabels.popupMenuItem(context),
              const PopupMenuDivider(),
              SelectionAvailableMenuOption.archive.popupMenuItem(context),
              SelectionAvailableMenuOption.delete.popupMenuItem(context),
            ]),
            onSelected: (menuOption) => onAvailableMenuOptionSelected(context, ref, selectedNotes, menuOption),
          ),
        if (notesStatus == NoteStatus.archived)
          PopupMenuButton<SelectionArchivedMenuOption>(
            itemBuilder: (context) => ([
              SelectionArchivedMenuOption.copy.popupMenuItem(context),
              SelectionArchivedMenuOption.share.popupMenuItem(context),
              const PopupMenuDivider(),
              SelectionArchivedMenuOption.unarchive.popupMenuItem(context),
            ]),
            onSelected: (menuOption) => onArchivedMenuOptionSelected(context, ref, selectedNotes, menuOption),
          ),
        if (notesStatus == NoteStatus.deleted)
          PopupMenuButton<SelectionDeletedMenuOption>(
            itemBuilder: (context) => ([
              SelectionDeletedMenuOption.restore.popupMenuItem(context),
              SelectionDeletedMenuOption.deletePermanently.popupMenuItem(context),
            ]),
            onSelected: (menuOption) => onDeletedMenuOptionSelected(context, ref, selectedNotes, menuOption),
          ),
        Padding(padding: Paddings.appBarActionsEnd),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(notesProvider(status: notesStatus, label: currentLabelFilter)).when(
          data: (notes) {
            return buildAppBar(
              context,
              ref,
              notes.where((note) => note.selected).toList(),
              notes.length,
            );
          },
          error: (exception, stackTrace) => ErrorPlaceholder(exception: exception, stackTrace: stackTrace),
          loading: () => const LoadingPlaceholder(),
        );
  }
}
