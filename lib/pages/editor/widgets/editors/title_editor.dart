import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../common/constants/paddings.dart';
import '../../../../common/extensions/build_context_extension.dart';
import '../../../../common/preferences/preference_key.dart';
import '../../../../models/note/note.dart';
import '../../../../providers/notes/notes_provider.dart';
import '../../../../providers/notifiers/notifiers.dart';

/// Title editor.
class TitleEditor extends ConsumerStatefulWidget {
  /// Text field allowing to edit the title of a note.
  const TitleEditor({super.key, required this.readOnly, required this.isNewNote, required this.onSubmitted});

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
  late final TextEditingController titleController;

  @override
  void initState() {
    super.initState();

    titleController = TextEditingController(text: currentNoteNotifier.value?.title);
  }

  @override
  void dispose() {
    titleController.dispose();

    super.dispose();
  }

  /// Saves the [newTitle] of the [note] in the database.
  void onChanged(Note? note, String? newTitle) {
    if (note == null || newTitle == null) {
      return;
    }

    note.title = newTitle;

    // Archived notes are not filtered by label
    final label = note.archived ? null : currentLabelFilter;
    ref.read(notesProvider(status: note.status, label: label).notifier).edit(note);
  }

  @override
  Widget build(BuildContext context) {
    final focusTitleOnNewNote = PreferenceKey.focusTitleOnNewNote.preferenceOrDefault;
    final biggerTitles = PreferenceKey.biggerTitles.preferenceOrDefault;

    var titleStyle = biggerTitles ? Theme.of(context).textTheme.headlineSmall : Theme.of(context).textTheme.titleLarge;

    return Padding(
      padding: Paddings.pageHorizontal,
      child: ValueListenableBuilder(
        valueListenable: currentNoteNotifier,
        builder: (context, currentNote, child) {
          return TextField(
            readOnly: widget.readOnly,
            autofocus: widget.isNewNote && focusTitleOnNewNote,
            textCapitalization: TextCapitalization.sentences,
            textInputAction: TextInputAction.next,
            style: titleStyle,
            decoration: InputDecoration.collapsed(hintText: context.l.hint_title),
            controller: titleController,
            onChanged: (text) => onChanged(currentNote, text),
            onSubmitted: (_) => widget.onSubmitted(),
          );
        },
      ),
    );
  }
}
