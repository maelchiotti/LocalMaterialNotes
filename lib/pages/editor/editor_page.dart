import 'dart:convert';

import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:fleather/fleather.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localmaterialnotes/common/placeholders/loading_placeholder.dart';
import 'package:localmaterialnotes/common/routing/router.dart';
import 'package:localmaterialnotes/models/note/note.dart';
import 'package:localmaterialnotes/pages/editor/widgets/editor_field.dart';
import 'package:localmaterialnotes/pages/editor/widgets/editor_toolbar.dart';
import 'package:localmaterialnotes/providers/notes/notes_provider.dart';
import 'package:localmaterialnotes/providers/notifiers.dart';
import 'package:localmaterialnotes/utils/constants/constants.dart';
import 'package:localmaterialnotes/utils/constants/paddings.dart';
import 'package:localmaterialnotes/utils/preferences/preference_key.dart';

class EditorPage extends ConsumerStatefulWidget {
  EditorPage(EditorParameters editorParameters)
      : _readOnly = editorParameters?['readonly'] ?? false,
        _autofocus = editorParameters?['autofocus'] ?? false;

  final bool _readOnly;
  final bool _autofocus;

  @override
  ConsumerState<EditorPage> createState() => _EditorState();
}

class _EditorState extends ConsumerState<EditorPage> {
  final titleController = TextEditingController();

  @override
  void initState() {
    super.initState();

    BackButtonInterceptor.add(_interceptor);
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(_interceptor);

    super.dispose();
  }

  bool _interceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    if (!Navigator.canPop(navigatorKey.currentContext!)) {
      return false;
    }

    Navigator.pop(navigatorKey.currentContext!);

    return true;
  }

  void _synchronizeTitle(Note note, String? newTitle) {
    if (newTitle == null) {
      return;
    }

    note.title = newTitle;

    ref.read(notesProvider.notifier).edit(note);
  }

  void _synchronizeContent(Note note) {
    final editorController = fleatherControllerNotifier.value;

    if (editorController == null) {
      return;
    }

    fleatherControllerCanUndoNotifier.value = editorController.canUndo;
    fleatherControllerCanRedoNotifier.value = editorController.canRedo;

    note.content = jsonEncode(editorController.document.toDelta().toJson());

    ref.read(notesProvider.notifier).edit(note);
  }

  @override
  Widget build(BuildContext context) {
    final note = currentNoteNotifier.value;

    if (note == null) {
      return const LoadingPlaceholder();
    }

    final editorController = fleatherControllerNotifier.value ??= FleatherController(
      document: note.document,
    )..addListener(() => _synchronizeContent(note));

    titleController.text = note.title;

    final showToolbar = PreferenceKey.showToolbar.getPreferenceOrDefault<bool>();

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
                  onChanged: (text) => _synchronizeTitle(note, text),
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
            return showToolbar && hasFocus && KeyboardVisibilityProvider.isKeyboardVisible(context)
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
