import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/navigation/app_bars/notes/notes_app_bar.dart';
import '../../common/navigation/side_navigation.dart';
import '../../common/navigation/top_navigation.dart';
import '../../common/widgets/keys.dart';
import '../../common/widgets/notes/notes_list.dart';
import '../../models/label/label.dart';
import '../../models/note/note_status.dart';
import '../../providers/notifiers/notifiers.dart';
import '../../providers/preferences/preferences_provider.dart';
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

  @override
  Widget build(BuildContext context) {
    final availableNotesTypes = ref.watch(
      preferencesProvider.select((preferences) => preferences.availableNotesTypes),
    );

    return Scaffold(
      appBar: TopNavigation(
        appbar: NotesAppBar(
          key: Keys.appBarNotesBin,
          label: widget.label,
          notesStatus: NoteStatus.available,
        ),
        notesStatus: NoteStatus.available,
      ),
      drawer: SideNavigation(),
      floatingActionButtonLocation: availableNotesTypes.length > 1 ? ExpandableFab.location : null,
      floatingActionButton: AddNoteFab(
        key: Keys.fabAddNote,
      ),
      body: NotesList(
        key: Keys.notesPageNotesList,
        notesStatus: NoteStatus.available,
        label: widget.label,
      ),
    );
  }
}
