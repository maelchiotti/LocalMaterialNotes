import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localmaterialnotes/common/navigation/app_bars/notes_app_bar.dart';
import 'package:localmaterialnotes/common/navigation/side_navigation.dart';
import 'package:localmaterialnotes/common/navigation/top_navigation.dart';
import 'package:localmaterialnotes/common/widgets/notes/notes_list.dart';
import 'package:localmaterialnotes/pages/notes/widgets/fab_add_note.dart';
import 'package:localmaterialnotes/utils/keys.dart';

/// Page displaying the list of notes.
///
/// Contains:
///   - The list of notes.
///   - The FAB to add a note.
class NotesPage extends ConsumerStatefulWidget {
  /// Default constructor.
  const NotesPage({super.key});

  @override
  ConsumerState<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends ConsumerState<NotesPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: TopNavigation(
        appbar: NotesAppBar(
          key: Keys.appBarNotesBin,
        ),
      ),
      drawer: SideNavigation(),
      floatingActionButton: FabAddNote(
        key: Keys.fabAddNote,
      ),
      body: NotesList(key: Keys.notesPageNotesList),
    );
  }
}
