import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/navigation/app_bars/notes/notes_app_bar.dart';
import '../../common/navigation/side_navigation.dart';
import '../../common/navigation/top_navigation.dart';
import '../../common/widgets/notes/notes_list.dart';
import '../../models/note/note_status.dart';

/// List of archived notes.
class ArchivesPage extends ConsumerStatefulWidget {
  /// Default constructor.
  const ArchivesPage({super.key});

  @override
  ConsumerState<ArchivesPage> createState() => _ArchivesPageState();
}

class _ArchivesPageState extends ConsumerState<ArchivesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopNavigation(
        appbar: NotesAppBar(notesStatus: NoteStatus.archived),
        notesStatus: NoteStatus.archived,
      ),
      drawer: SideNavigation(),
      body: NotesList(notesStatus: NoteStatus.archived),
    );
  }
}
