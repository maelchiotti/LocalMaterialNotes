import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localmaterialnotes/common/navigation/app_bars/notes_app_bar.dart';
import 'package:localmaterialnotes/common/navigation/side_navigation.dart';
import 'package:localmaterialnotes/common/navigation/top_navigation.dart';
import 'package:localmaterialnotes/common/widgets/notes/notes_list.dart';
import 'package:localmaterialnotes/models/label/label.dart';
import 'package:localmaterialnotes/pages/notes/widgets/add_note_fab.dart';
import 'package:localmaterialnotes/providers/notes/notes/notes_provider.dart';
import 'package:localmaterialnotes/utils/keys.dart';

/// Page displaying the list of notes.
///
/// Contains:
///   - The list of notes.
///   - The FAB to add a note.
class NotesPage extends ConsumerWidget {
  /// Default constructor.
  const NotesPage({
    super.key,
    required this.label,
  });

  final Label? label;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    label != null ? ref.read(notesProvider.notifier).filter(label!) : ref.read(notesProvider.notifier).get();

    return const Scaffold(
      appBar: TopNavigation(
        appbar: NotesAppBar(
          key: Keys.appBarNotesBin,
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
