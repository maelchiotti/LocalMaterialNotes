import 'dart:convert';

import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:fleather/fleather.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localmaterialnotes/common/constants/constants.dart';
import 'package:localmaterialnotes/common/constants/paddings.dart';
import 'package:localmaterialnotes/common/preferences/preference_key.dart';
import 'package:localmaterialnotes/common/routing/router.dart';
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
class EditorPage extends ConsumerStatefulWidget {
  EditorPage(EditorParameters editorParameters)
      : _readOnly = editorParameters?['readonly'] ?? false,
        _autofocus = editorParameters?['autofocus'] ?? false;

  /// Whether the text fields should be read only.
  final bool _readOnly;

  /// Whether to automatically focus the content text field.
  final bool _autofocus;

  @override
  ConsumerState<EditorPage> createState() => _EditorState();
}

class _EditorState extends ConsumerState<EditorPage> {
  final note = currentNoteNotifier.value;

  late final TextEditingController titleController;
  late final FleatherController editorController;

  @override
  void initState() {
    super.initState();

    BackButtonInterceptor.add(_interceptor);

    if (note != null) {
      titleController = TextEditingController(text: note!.title);
      editorController = FleatherController(document: note!.document);

      editorController.addListener(() => _synchronizeContent(note!));

      fleatherControllerNotifier.value = editorController;
    }
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(_interceptor);

    super.dispose();
  }

  /// Actions to perform when the back button is intercepted.
  ///
  /// If the `Navigator` can't be popped, it means the menu isn't opened and the route should be popped (going back
  /// to the notes list or the bin). Otherwise, the menu is open, so it should be closed but the route shouldn't
  /// be popped (staying in the editor).
  bool _interceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    if (!Navigator.canPop(navigatorKey.currentContext!)) {
      currentNoteNotifier.value = null;
      fleatherControllerNotifier.value = null;

      return false;
    } else {
      Navigator.pop(navigatorKey.currentContext!);

      return true;
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
    final isKeyboardVisible = KeyboardVisibilityProvider.isKeyboardVisible(context);

    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: Paddings.custom.pageButBottom,
            child: Column(
              children: [
                TextField(
                  readOnly: widget._readOnly,
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
                      readOnly: widget._readOnly,
                      autofocus: widget._autofocus,
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
                    child: EditorToolbar(editorController),
                  )
                : Container();
          },
        ),
      ],
    );
  }
}
