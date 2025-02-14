import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/note/note.dart';
import '../../../models/note/note_status.dart';
import '../../../providers/notes/notes_provider.dart';
import '../../../providers/notifiers/notifiers.dart';
import '../../actions/notes/archive.dart';
import '../../actions/notes/copy.dart';
import '../../actions/notes/delete.dart';
import '../../actions/notes/labels.dart';
import '../../actions/notes/pin.dart';
import '../../actions/notes/restore.dart';
import '../../actions/notes/select.dart';
import '../../actions/notes/share.dart';
import '../../actions/notes/unarchive.dart';
import '../../constants/constants.dart';
import '../../constants/paddings.dart';
import '../../constants/separators.dart';
import '../../preferences/preference_key.dart';
import '../../widgets/placeholders/error_placeholder.dart';
import '../../widgets/placeholders/loading_placeholder.dart';
import '../enums/archives_menu_option.dart';
import '../enums/bin_menu_option.dart';
import '../enums/notes_menu_option.dart';

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
  Future<void> onNotesMenuOptionSelected(
    BuildContext context,
    WidgetRef ref,
    List<Note> notes,
    NotesMenuOption menuOption,
  ) async {
    switch (menuOption) {
      case NotesMenuOption.copy:
        await copyNotes(notes: notes);
      case NotesMenuOption.share:
        await shareNotes(notes: notes);
      case NotesMenuOption.togglePin:
        await togglePinNotes(context, ref, notes: notes);
      case NotesMenuOption.addLabels:
        addLabels(context, ref, notes: notes);
      case NotesMenuOption.archive:
        await archiveNote(context, ref);
      case NotesMenuOption.delete:
        await deleteNotes(context, ref, notes: notes);
    }
  }

  /// Action to perform on the archived [notes] depending on the selected [menuOption].
  Future<void> onArchivesMenuOptionSelected(
    BuildContext context,
    WidgetRef ref,
    List<Note> notes,
    ArchivesMenuOption menuOption,
  ) async {
    switch (menuOption) {
      case ArchivesMenuOption.unarchive:
        await unarchiveNotes(context, ref, notes: notes);
      default:
        throw Exception('This action cannot be performed in the notes selection app bar: $menuOption');
    }
  }

  /// Action to perform on the deleted [notes] depending on the selected [menuOption].
  Future<void> onBinMenuOptionSelected(
    BuildContext context,
    WidgetRef ref,
    List<Note> notes,
    BinMenuOption menuOption,
  ) async {
    switch (menuOption) {
      case BinMenuOption.restore:
        await restoreNotes(context, ref, notes: notes);
      case BinMenuOption.deletePermanently:
        await permanentlyDeleteNotes(context, ref, notes: notes);
      default:
        throw Exception('This action cannot be performed in the notes selection app bar: $menuOption');
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
    final enableLabels = PreferenceKey.enableLabels.getPreferenceOrDefault();

    final allSelected = selectedNotes.length == totalNotesCount;

    return AppBar(
      leading: BackButton(
        onPressed: () => exitNotesSelectionMode(context, ref, notesStatus: notesStatus),
      ),
      title: Text('${selectedNotes.length}'),
      actions: [
        IconButton(
          icon: Icon(allSelected ? Icons.deselect : Icons.select_all),
          tooltip: allSelected ? l.tooltip_unselect_all : flutterL?.selectAllButtonLabel ?? 'Select all',
          onPressed: () => allSelected
              ? unselectAllNotes(context, ref, notesStatus: notesStatus)
              : selectAllNotes(context, ref, notesStatus: notesStatus),
        ),
        Padding(
          padding: Paddings.appBarSeparator,
          child: Separator.divider1indent16.vertical,
        ),
        if (notesStatus == NoteStatus.available)
          PopupMenuButton<NotesMenuOption>(
            itemBuilder: (context) => ([
              NotesMenuOption.copy.popupMenuItem(context),
              NotesMenuOption.share.popupMenuItem(context),
              const PopupMenuDivider(),
              NotesMenuOption.togglePin.popupMenuItem(context),
              if (enableLabels) NotesMenuOption.addLabels.popupMenuItem(context),
              const PopupMenuDivider(),
              NotesMenuOption.archive.popupMenuItem(context),
              NotesMenuOption.delete.popupMenuItem(context),
            ]),
            onSelected: (menuOption) => onNotesMenuOptionSelected(context, ref, selectedNotes, menuOption),
          ),
        if (notesStatus == NoteStatus.archived)
          PopupMenuButton<ArchivesMenuOption>(
            itemBuilder: (context) => ([
              ArchivesMenuOption.unarchive.popupMenuItem(context),
            ]),
            onSelected: (menuOption) => onArchivesMenuOptionSelected(context, ref, selectedNotes, menuOption),
          ),
        if (notesStatus == NoteStatus.deleted)
          PopupMenuButton<BinMenuOption>(
            itemBuilder: (context) => ([
              BinMenuOption.restore.popupMenuItem(context),
              BinMenuOption.deletePermanently.popupMenuItem(context),
            ]),
            onSelected: (menuOption) => onBinMenuOptionSelected(context, ref, selectedNotes, menuOption),
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
