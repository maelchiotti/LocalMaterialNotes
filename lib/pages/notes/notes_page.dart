import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/actions/labels/select.dart';
import '../../common/actions/notes/select.dart';
import '../../common/constants/constants.dart';
import '../../common/navigation/app_bars/notes/notes_app_bar.dart';
import '../../common/navigation/side_navigation.dart';
import '../../common/navigation/top_navigation.dart';
import '../../common/widgets/notes/notes_list.dart';
import '../../models/label/label.dart';
import '../../models/note/note_status.dart';
import '../../models/note/types/note_type.dart';
import '../../providers/notifiers/notifiers.dart';
import 'widgets/add_note_fab.dart';

/// List of available notes.
class NotesPage extends ConsumerStatefulWidget {
  /// The list of the notes and the FAB to add a new note.
  ///
  /// The notes can optionally be filtered by a [label].
  const NotesPage({super.key, required this.label});

  /// The label to use to filter the notes.
  ///
  /// Only the notes having this label will be shown in the list.
  final Label? label;

  @override
  ConsumerState<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends ConsumerState<NotesPage> {
  @override
  void dispose() {
    currentLabelFilter = null;

    super.dispose();
  }

  void onDrawerChanged(bool open) {
    canPopNotifier.update();
  }

  void onPopInvoked(bool didPop) {
    if (didPop) {
      return;
    }

    // Closes the expandable FAB to add a note
    if (notesPageScaffoldKey.currentState != null && notesPageScaffoldKey.currentState!.isDrawerOpen) {
      notesPageScaffoldKey.currentState!.closeDrawer();
    } else if (addNoteFabKey.currentState != null && addNoteFabKey.currentState!.isOpen) {
      addNoteFabKey.currentState!.toggle();
    } else {
      // Unselects all notes
      if (isNotesSelectionModeNotifier.value) {
        unselectAllNotes(context, ref, notesStatus: NoteStatus.available);
        unselectAllNotes(context, ref, notesStatus: NoteStatus.archived);
        unselectAllNotes(context, ref, notesStatus: NoteStatus.deleted);

        isNotesSelectionModeNotifier.value = false;
      }

      // Unselects all labels
      if (isLabelsSelectionModeNotifier.value) {
        unselectAllLabels(ref);

        isLabelsSelectionModeNotifier.value = false;
      }
    }

    canPopNotifier.update();
  }

  @override
  Widget build(BuildContext context) {
    final availableNotesTypes = NoteType.available;

    return Scaffold(
      key: notesPageScaffoldKey,
      appBar: TopNavigation(
        appbar: NotesAppBar(label: widget.label, notesStatus: NoteStatus.available),
        notesStatus: NoteStatus.available,
      ),
      drawer: SideNavigation(),
      floatingActionButtonLocation: availableNotesTypes.length > 1 ? ExpandableFab.location : null,
      floatingActionButton: AddNoteFab(),
      onDrawerChanged: onDrawerChanged,
      body: ValueListenableBuilder(
        valueListenable: canPopNotifier,
        builder: (context, canPop, child) {
          return PopScope(
            canPop: canPop,
            onPopInvokedWithResult: (didPop, result) => onPopInvoked(didPop),
            child: NotesList(notesStatus: NoteStatus.available, label: widget.label),
          );
        },
      ),
    );
  }
}
