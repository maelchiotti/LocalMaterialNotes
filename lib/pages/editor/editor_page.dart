import 'dart:convert';

import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:fleather/fleather.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localmaterialnotes/common/placeholders/loading_placeholder.dart';
import 'package:localmaterialnotes/common/routing/router.dart';
import 'package:localmaterialnotes/models/note/note.dart';
import 'package:localmaterialnotes/pages/editor/editor_field.dart';
import 'package:localmaterialnotes/pages/editor/editor_toolbar.dart';
import 'package:localmaterialnotes/providers/current_note/current_note_provider.dart';
import 'package:localmaterialnotes/providers/editor_controller/editor_controller_provider.dart';
import 'package:localmaterialnotes/providers/notes/notes_provider.dart';
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
  FleatherController? fleatherController;

  bool fleatherFieldHasFocus = false;

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
    if (fleatherController == null) {
      return;
    }

    note.content = jsonEncode(fleatherController!.document.toDelta().toJson());

    ref.read(notesProvider.notifier).edit(note);
  }

  @override
  Widget build(BuildContext context) {
    final note = ref.watch(currentNoteProvider);

    if (note == null) {
      return const LoadingPlaceholder();
    }

    final showToolbar = PreferenceKey.showToolbar.getPreferenceOrDefault<bool>();

    titleController.text = note.title;

    if (fleatherController == null) {
      fleatherController = FleatherController(document: note.document);
      fleatherController!.addListener(() => _synchronizeContent(note));

      Future(() {
        ref.read(editorControllerProvider.notifier).set(fleatherController!);
      });
    }

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
                      fleatherController: fleatherController!,
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
          builder: (_, hasFocus, ___) {
            return showToolbar && hasFocus && KeyboardVisibilityProvider.isKeyboardVisible(context)
                ? ColoredBox(
                    color: Theme.of(context).colorScheme.surfaceContainerHigh,
                    child: EditorToolbar(fleatherController!),
                  )
                : Container();
          },
        ),
      ],
    );
  }
}
