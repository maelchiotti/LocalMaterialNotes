import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../common/constants/constants.dart';
import '../../common/navigation/app_bars/notes_app_bar.dart';
import '../../common/navigation/side_navigation.dart';
import '../../common/navigation/top_navigation.dart';
import '../../common/widgets/notes/notes_list.dart';
import 'widgets/empty_bin_fab.dart';
import '../../utils/keys.dart';

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
  Widget build(BuildContext context) => Scaffold(
        appBar: TopNavigation(
          appbar: NotesAppBar(
            key: Keys.appBarNotesBin,
            title: l.navigation_bin,
          ),
        ),
        drawer: SideNavigation(),
        floatingActionButton: EmptyBinFab(
          key: Keys.fabEmptyBin,
        ),
        body: NotesList(
          key: Keys.notesPageNotesList,
          notesPage: false,
        ),
      );
}
