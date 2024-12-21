import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../common/constants/constants.dart';
import '../../common/navigation/app_bars/notes_app_bar.dart';
import '../../common/navigation/side_navigation.dart';
import '../../common/navigation/top_navigation.dart';
import '../../common/widgets/notes/notes_list.dart';
import '../../models/label/label.dart';
import 'widgets/add_note_fab.dart';
import '../../providers/notes/notes_provider.dart';
import '../../utils/keys.dart';

/// List of notes.
class NotesPage extends ConsumerWidget {
  /// The list of the notes and the FAB to add a new note.
  ///
  /// The notes can optionally be filtered by a [label].
  const NotesPage({
    super.key,
    this.label,
  });

  /// The label to use to filter the notes.
  ///
  /// Only the notes having this label will be shown in the list.
  final Label? label;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Filter the notes if the label is set, get all the notes otherwise
    label != null ? ref.read(notesProvider.notifier).filter(label!) : ref.read(notesProvider.notifier).get();

    return Scaffold(
      appBar: TopNavigation(
        appbar: NotesAppBar(
          key: Keys.appBarNotesBin,
          title: label?.name ?? l.navigation_notes,
          label: label,
        ),
      ),
      drawer: SideNavigation(),
      floatingActionButton: AddNoteFab(
        key: Keys.fabAddNote,
      ),
      body: NotesList(key: Keys.notesPageNotesList),
    );
  }
}
