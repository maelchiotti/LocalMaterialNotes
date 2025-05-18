import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/navigation/app_bars/notes/notes_app_bar.dart';
import '../../common/navigation/side_navigation.dart';
import '../../common/navigation/top_navigation.dart';
import '../../common/widgets/notes/notes_list.dart';
import '../../models/note/note_status.dart';
import 'widgets/empty_bin_fab.dart';

/// List of deleted notes.
class BinPage extends ConsumerStatefulWidget {
  /// Default constructor.
  const BinPage({super.key});

  @override
  ConsumerState<BinPage> createState() => _BinPageState();
}

class _BinPageState extends ConsumerState<BinPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopNavigation(appbar: NotesAppBar(notesStatus: NoteStatus.deleted), notesStatus: NoteStatus.deleted),
      drawer: SideNavigation(),
      floatingActionButton: EmptyBinFab(),
      body: NotesList(notesStatus: NoteStatus.deleted),
    );
  }
}
