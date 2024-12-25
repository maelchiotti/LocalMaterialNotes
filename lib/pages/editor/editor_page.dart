import 'dart:convert';

import 'package:fleather/fleather.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../common/constants/constants.dart';
import '../../common/constants/paddings.dart';
import '../../common/navigation/app_bars/editor_app_bar.dart';
import '../../common/navigation/top_navigation.dart';
import '../../common/preferences/preference_key.dart';
import '../../common/widgets/placeholders/loading_placeholder.dart';
import '../../models/note/note.dart';
import '../../providers/notes/notes_provider.dart';
import '../../providers/notifiers/notifiers.dart';
import '../../utils/keys.dart';
import 'widgets/editor_field.dart';
import 'widgets/editor_labels_list.dart';
import 'widgets/editor_toolbar.dart';

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

  /// Whether the page is read only.
  final bool readOnly;

  /// Whether this is a new note, so the title or content field should be auto focused
  /// and the editor mode should be forced to editing.
  final bool isNewNote;

  @override
  ConsumerState<NotesEditorPage> createState() => _EditorState();
}

class _EditorState extends ConsumerState<NotesEditorPage> {
  /// Controller of the title of the note.
  late TextEditingController titleController;

  /// Controller of the content of the note.
  late FleatherController editorController;

  @override
  void initState() {
    super.initState();

    // If this is a new note, force the editing mode
    if (widget.isNewNote) {
      isFleatherEditorEditMode.value = true;
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
    final showEditorModeButton = PreferenceKey.editorModeButton.getPreferenceOrDefault();
    final showToolbar = PreferenceKey.showToolbar.getPreferenceOrDefault();
    final focusTitleOnNewNote = PreferenceKey.focusTitleOnNewNote.getPreferenceOrDefault();
    final enableLabels = PreferenceKey.enableLabels.getPreferenceOrDefault();
    final showLabelsListInEditorPage = PreferenceKey.showLabelsListInEditorPage.getPreferenceOrDefault();

    return ValueListenableBuilder(
      valueListenable: currentNoteNotifier,
      builder: (context, currentNote, child) {
        if (currentNote == null) {
          return const LoadingPlaceholder();
        }

        titleController = TextEditingController(text: currentNote.title);

        editorController = FleatherController(document: currentNote.document);
        editorController.addListener(() => _synchronizeContent(currentNote));

        fleatherControllerNotifier.value = editorController;

        final showLabelsList = enableLabels && showLabelsListInEditorPage && currentNote.labelsVisibleSorted.isNotEmpty;

        return Scaffold(
          appBar: const TopNavigation(
            appbar: EditorAppBar(
              key: Keys.appBarEditor,
            ),
          ),
          body: ValueListenableBuilder(
            valueListenable: isFleatherEditorEditMode,
            builder: (context, isEditMode, child) => Column(
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
                            hintText: l.hint_title,
                          ),
                          controller: titleController,
                          onChanged: (text) => _synchronizeTitle(currentNote, text),
                          onSubmitted: _requestEditorFocus,
                        ),
                        Gap(8.0),
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
                SafeArea(
                  child: Column(
                    children: [
                      if (showLabelsList) EditorLabelsList(readOnly: widget.readOnly),
                      if (showToolbar && isEditMode && !currentNote.deleted)
                        EditorToolbar(editorController: editorController),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
