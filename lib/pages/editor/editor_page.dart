import 'dart:convert';

import 'package:fleather/fleather.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localmaterialnotes/common/constants/constants.dart';
import 'package:localmaterialnotes/common/constants/paddings.dart';
import 'package:localmaterialnotes/common/preferences/preference_key.dart';
import 'package:localmaterialnotes/common/widgets/placeholders/loading_placeholder.dart';
import 'package:localmaterialnotes/models/note/note.dart';
import 'package:localmaterialnotes/pages/editor/widgets/editor_field.dart';
import 'package:localmaterialnotes/pages/editor/widgets/editor_toolbar.dart';
import 'package:localmaterialnotes/pages/editor/widgets/fab_toggle_editor_mode.dart';
import 'package:localmaterialnotes/providers/notes/notes_provider.dart';
import 'package:localmaterialnotes/providers/notifiers.dart';
import 'package:localmaterialnotes/utils/keys.dart';

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
    required this.isNewNote,
  });

  /// Whether the text fields should be read only.
  final bool readOnly;

  /// Whether this is a new note, so the title or content field should be auto focused
  /// and the editor mode should be forced to editing.
  final bool isNewNote;

  @override
  ConsumerState<NotesEditorPage> createState() => _EditorState();
}

class _EditorState extends ConsumerState<NotesEditorPage> {
  /// Current note being edited.
  final note = currentNoteNotifier.value;

  /// Controller of the title of the note.
  late final TextEditingController titleController;

  /// Controller of the content of the note.
  late final FleatherController editorController;

  @override
  void initState() {
    super.initState();

    if (note != null) {
      titleController = TextEditingController(text: note!.title);
      editorController = FleatherController(document: note!.document);

      editorController.addListener(() => _synchronizeContent(note!));

      fleatherControllerNotifier.value = editorController;

      // If this is a new note, force the editing mode
      if (widget.isNewNote) {
        isFleatherEditorEditMode.value = true;
      }
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

  /// Request focus on the content editor.
  void _requestEditorFocus(_) {
    editorFocusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    if (note == null) {
      return const LoadingPlaceholder();
    }

    final showEditorModeButton = PreferenceKey.editorModeButton.getPreferenceOrDefault<bool>();
    final showToolbar = PreferenceKey.showToolbar.getPreferenceOrDefault<bool>();
    final focusTitleOnNewNote = PreferenceKey.focusTitleOnNewNote.getPreferenceOrDefault<bool>();

    return Scaffold(
      floatingActionButton: showEditorModeButton ? const FabToggleEditorMode() : null,
      body: ValueListenableBuilder(
        valueListenable: isFleatherEditorEditMode,
        builder: (context, isEditMode, child) {
          return Column(
            children: [
              Expanded(
                child: Padding(
                  padding: Paddings.pageButBottom,
                  child: Column(
                    children: [
                      TextField(
                        key: Keys.editorTitleTextField,
                        readOnly: widget.readOnly,
                        autofocus: widget.isNewNote && focusTitleOnNewNote,
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
                      Padding(padding: Paddings.vertical(8)),
                      Expanded(
                        child: Focus(
                          onFocusChange: (hasFocus) => fleatherFieldHasFocusNotifier.value = hasFocus,
                          child: EditorField(
                            key: Keys.editorContentTextField,
                            fleatherController: editorController,
                            readOnly: widget.readOnly || (showEditorModeButton && !isEditMode),
                            autofocus: widget.isNewNote && !focusTitleOnNewNote,
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
                  return showToolbar && isEditMode
                      ?
                      // Use a SafeArea to prevent the toolbar from displaying under the system bottom UI
                      SafeArea(
                          child: ColoredBox(
                            color: Theme.of(context).colorScheme.surfaceContainerHigh,
                            child: EditorToolbar(editorController: editorController),
                          ),
                        )
                      : Container();
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
