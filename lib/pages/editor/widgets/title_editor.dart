import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/constants/constants.dart';
import '../../../common/constants/paddings.dart';
import '../../../common/preferences/preference_key.dart';
import '../../../models/note/note.dart';
import '../../../providers/notes/notes_provider.dart';
import '../../../providers/notifiers/notifiers.dart';

/// Title editor.
class TitleEditor extends ConsumerStatefulWidget {
  /// Text field allowing to edit the title of a note.
  const TitleEditor({
    super.key,
    required this.readOnly,
    required this.isNewNote,
    required this.onSubmitted,
  });

  /// Whether the page is read only.
  final bool readOnly;

  /// Whether the note was just created.
  final bool isNewNote;

  /// Called when the title is submitted.
  final VoidCallback onSubmitted;

  @override
  ConsumerState<TitleEditor> createState() => _TitleEditorState();
}

class _TitleEditorState extends ConsumerState<TitleEditor> {
  /// Controller of the title of the note.
  late TextEditingController titleController;

  /// Saves the [newTitle] of the [note] in the database.
  void onChanged(Note? note, String? newTitle) {
    if (note == null || newTitle == null) {
      return;
    }

    note.title = newTitle;

    ref.read(notesProvider(label: currentLabelFilter).notifier).edit(note);
  }

  @override
  Widget build(BuildContext context) {
    final focusTitleOnNewNote = PreferenceKey.focusTitleOnNewNote.getPreferenceOrDefault();

    return Padding(
      padding: Paddings.pageHorizontal,
      child: ValueListenableBuilder(
        valueListenable: currentNoteNotifier,
        builder: (context, currentNote, child) {
          titleController = TextEditingController(text: currentNote?.title);

          return TextField(
            readOnly: widget.readOnly,
            autofocus: widget.isNewNote && focusTitleOnNewNote,
            textCapitalization: TextCapitalization.sentences,
            textInputAction: TextInputAction.next,
            style: Theme.of(context).textTheme.titleLarge,
            decoration: InputDecoration.collapsed(
              hintText: l.hint_title,
            ),
            controller: titleController,
            onChanged: (text) => onChanged(currentNote, text),
            onSubmitted: (_) => widget.onSubmitted,
          );
        },
      ),
    );
  }
}
