import 'dart:convert';

import 'package:fleather/fleather.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localmaterialnotes/common/constants/constants.dart';
import 'package:localmaterialnotes/common/constants/paddings.dart';
import 'package:localmaterialnotes/common/preferences/preference_key.dart';
import 'package:localmaterialnotes/common/widgets/placeholders/loading_placeholder.dart';
import 'package:localmaterialnotes/models/note/note.dart';
import 'package:localmaterialnotes/pages/editor/widgets/editor_field.dart';
import 'package:localmaterialnotes/pages/editor/widgets/editor_toolbar.dart';
import 'package:localmaterialnotes/providers/notes/notes_provider.dart';
import 'package:localmaterialnotes/providers/notifiers.dart';

/// Page displaying the note editor.
///
/// Contains:
///   - The text field for the title of the note.
///   - The text field for the content of the note.
class NotesEditorPage extends ConsumerStatefulWidget {
  /// Default constructor.
  const NotesEditorPage({
    super.key,
    required this.readOnly,
    required this.autofocus,
  });

  /// Whether the text fields should be read only.
  final bool readOnly;

  /// Whether to automatically focus the content text field.
  final bool autofocus;

  @override
  ConsumerState<NotesEditorPage> createState() => _EditorState();
}

class _EditorState extends ConsumerState<NotesEditorPage> {
  final note = currentNoteNotifier.value;

  late final TextEditingController titleController;
  late final FleatherController editorController;

  @override
  void initState() {
    super.initState();

    if (note != null) {
      titleController = TextEditingController(text: note!.title);
      editorController = FleatherController(document: note!.document);

      editorController.addListener(() => _synchronizeContent(note!));

      fleatherControllerNotifier.value = editorController;
    }
  }

  /// Saves the [newTitle] of the [note] in the database.
  void _synchronizeTitle(Note note, String? newTitle) {
    if (newTitle == null) {
      return;
    }

    note.title = newTitle;

    ref.read(notesProvider.notifier).edit(note);
  }

  /// Saves the new content of the [note] in the database.
  ///
  /// Also updates whether the undo/redo actions can be used.
  void _synchronizeContent(Note note) {
    fleatherControllerCanUndoNotifier.value = editorController.canUndo;
    fleatherControllerCanRedoNotifier.value = editorController.canRedo;

    note.content = jsonEncode(editorController.document.toDelta().toJson());

    ref.read(notesProvider.notifier).edit(note);
  }

  void _requestEditorFocus(_) {
    editorFocusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    if (note == null) {
      return const LoadingPlaceholder();
    }

    final showToolbar = PreferenceKey.showToolbar.getPreferenceOrDefault<bool>();
    final focusTitleOnNewNote = PreferenceKey.focusTitleOnNewNote.getPreferenceOrDefault<bool>();

    final isKeyboardVisible = KeyboardVisibilityProvider.isKeyboardVisible(context);

    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: Paddings.custom.pageButBottom,
            child: Column(
              children: [
                TextField(
                  readOnly: widget.readOnly,
                  autofocus: widget.autofocus && focusTitleOnNewNote,
                  textCapitalization: TextCapitalization.sentences,
                  textInputAction: TextInputAction.next,
                  style: Theme.of(context).textTheme.titleLarge,
                  decoration: InputDecoration.collapsed(
                    hintText: localizations.hint_title,
                  ),
                  controller: titleController,
                  onChanged: (text) => _synchronizeTitle(note!, text),
                  onSubmitted: _requestEditorFocus,
                ),
                Padding(padding: Paddings.padding8.vertical),
                Expanded(
                  child: Focus(
                    onFocusChange: (hasFocus) => fleatherFieldHasFocusNotifier.value = hasFocus,
                    child: EditorField(
                      fleatherController: editorController,
                      readOnly: widget.readOnly,
                      autofocus: widget.autofocus && !focusTitleOnNewNote,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        ValueListenableBuilder(
          valueListenable: fleatherFieldHasFocusNotifier,
          builder: (context, hasFocus, child) {
            return showToolbar && hasFocus && isKeyboardVisible
                ? ColoredBox(
                    color: Theme.of(context).colorScheme.surfaceContainerHigh,
                    child: EditorToolbar(editorController: editorController),
                  )
                : Container();
          },
        ),
      ],
    );
  }
}
