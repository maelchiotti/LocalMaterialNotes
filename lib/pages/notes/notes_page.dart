import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localmaterialnotes/common/widgets/notes/notes_list.dart';
import 'package:localmaterialnotes/providers/notifiers.dart';
import 'package:localmaterialnotes/utils/keys.dart';

class NotesPage extends ConsumerStatefulWidget {
  const NotesPage();

  @override
  ConsumerState<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends ConsumerState<NotesPage> {
  @override
  Widget build(BuildContext context) {
    return NotesList(key: Keys.notesPageNotesList);
  }
}
