import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localmaterialnotes/common/navigation/app_bars/notes_app_bar.dart';
import 'package:localmaterialnotes/common/navigation/side_navigation.dart';
import 'package:localmaterialnotes/common/navigation/top_navigation.dart';
import 'package:localmaterialnotes/common/widgets/notes/notes_list.dart';
import 'package:localmaterialnotes/pages/bin/widgets/fab_empty_bin.dart';
import 'package:localmaterialnotes/utils/keys.dart';

/// Page displaying the deleted notes.
///
/// Contains:
///   - The list of deleted notes.
///   - The FAB to empty the bin.
class BinPage extends ConsumerStatefulWidget {
  /// Default constructor.
  const BinPage({super.key});

  @override
  ConsumerState<BinPage> createState() => _BinPageState();
}

class _BinPageState extends ConsumerState<BinPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: TopNavigation(
        appbar: NotesAppBar(
          key: Keys.appBarNotesBin,
        ),
      ),
      drawer: SideNavigation(),
      floatingActionButton: FabEmptyBin(
        key: Keys.fabEmptyBin,
      ),
      body: NotesList(key: Keys.notesPageNotesList),
    );
  }
}
