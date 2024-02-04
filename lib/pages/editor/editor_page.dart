import 'dart:convert';

import 'package:fleather/fleather.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localmaterialnotes/common/placeholders/loading_placeholder.dart';
import 'package:localmaterialnotes/models/note/note.dart';
import 'package:localmaterialnotes/providers/current_note/current_note_provider.dart';
import 'package:localmaterialnotes/providers/editor_controller/editor_controller_provider.dart';
import 'package:localmaterialnotes/providers/notes/notes_provider.dart';
import 'package:localmaterialnotes/utils/constants/constants.dart';
import 'package:localmaterialnotes/utils/constants/paddings.dart';
import 'package:url_launcher/url_launcher_string.dart';

class EditorPage extends ConsumerStatefulWidget {
  const EditorPage({
    this.readOnly = false,
    this.autofocus = false,
  });

  final bool readOnly;
  final bool autofocus;

  @override
  ConsumerState<EditorPage> createState() => _EditorState();
}

class _EditorState extends ConsumerState<EditorPage> {
  final titleController = TextEditingController();
  late FleatherController fleatherController;
  final fleatherFocusNode = FocusNode();

  void _synchronizeTitle(Note note, String? newTitle) {
    if (newTitle == null) return;

    ref.read(notesProvider.notifier).edit(note..title = newTitle);
  }

  void _synchronizeContent(Note note) {
    note.content = jsonEncode(fleatherController.document.toDelta().toJson());
    ref.read(notesProvider.notifier).edit(note);
  }

  void _launchUrl(String? url) {
    if (url == null) return;

    launchUrlString(url);
  }

  @override
  Widget build(BuildContext context) {
    final note = ref.watch(currentNoteProvider);

    if (note == null) return const LoadingPlaceholder();

    titleController.text = note.title;
    fleatherController = FleatherController(document: note.document);
    fleatherController.addListener(() => _synchronizeContent(note));

    Future(() {
      ref.read(editorControllerProvider.notifier).set(fleatherController);
    });

    return Padding(
      padding: Paddings.custom.pageButBottom,
      child: Column(
        children: [
          TextField(
            readOnly: widget.readOnly,
            autofocus: widget.autofocus,
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
            child: FleatherEditor(
              controller: fleatherController,
              focusNode: fleatherFocusNode,
              readOnly: widget.readOnly,
              expands: true,
              onLaunchUrl: _launchUrl,
              spellCheckConfiguration: SpellCheckConfiguration(
                spellCheckService: DefaultSpellCheckService(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
