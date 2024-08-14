import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localmaterialnotes/common/widgets/notes/notes_list.dart';
import 'package:localmaterialnotes/providers/notifiers.dart';
import 'package:localmaterialnotes/utils/keys.dart';

/// Page displaying the deleted notes.
///
/// Contains:
///   - The list of deleted notes.
///   - The FAB to empty the bin.
class BinPage extends ConsumerStatefulWidget {
  const BinPage();

  @override
  ConsumerState<BinPage> createState() => _BinPageState();
}

class _BinPageState extends ConsumerState<BinPage> {
  @override
  Widget build(BuildContext context) {
    return NotesList(key: Keys.notesPageNotesList);
  }
}
