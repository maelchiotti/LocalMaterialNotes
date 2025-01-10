import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/navigation/app_bars/notes_app_bar.dart';
import '../../common/navigation/side_navigation.dart';
import '../../common/navigation/top_navigation.dart';
import '../../common/widgets/notes/notes_list.dart';
import '../../providers/notifiers/notifiers.dart';
import '../../utils/keys.dart';
import 'widgets/add_note_fab.dart';

/// List of notes.
class NotesPage extends ConsumerStatefulWidget {
  /// The list of the notes and the FAB to add a new note.
  ///
  /// The notes can optionally be filtered by a [label].
  const NotesPage({super.key});

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
    return Scaffold(
      appBar: TopNavigation(
        appbar: NotesAppBar(
          key: Keys.appBarNotesBin,
        ),
      ),
      drawer: SideNavigation(),
      floatingActionButton: AddNoteFab(
        key: Keys.fabAddNote,
      ),
      body: NotesList(
        key: Keys.notesPageNotesList,
        label: currentLabelFilter,
      ),
    );
  }
}
