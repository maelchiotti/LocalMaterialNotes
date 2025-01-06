import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../common/constants/constants.dart';
import '../../../../models/note/note.dart';
import '../../../../providers/notes/notes_provider.dart';
import '../../../../providers/notifiers/notifiers.dart';

/// Plain text editor.
class PlainTextEditor extends ConsumerStatefulWidget {
  /// Text editor allowing to edit the plain text content of a [PlainTextNote].
  const PlainTextEditor({
    super.key,
    required this.note,
    required this.isNewNote,
    required this.readOnly,
    required this.autofocus,
  });

  /// The note to display.
  final PlainTextNote note;

  /// Whether the note was just created.
  final bool isNewNote;

  /// Whether the text fields are read only.
  final bool readOnly;

  /// Whether the text field should request focus.
  final bool autofocus;

  @override
  ConsumerState<PlainTextEditor> createState() => _PlainTextEditorState();
}

class _PlainTextEditorState extends ConsumerState<PlainTextEditor> {
  late final TextEditingController contentTextController;

  @override
  void initState() {
    super.initState();

    contentTextController = TextEditingController(text: widget.note.content);
  }

  void onFocusChange(bool hasFocus) {
    editorHasFocusNotifier.value = hasFocus;
  }

  void onChanged(String content) {
    PlainTextNote note = widget.note..content = content;

    ref.read(notesProvider.notifier).edit(note);
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: onFocusChange,
      child: TextField(
        controller: contentTextController,
        focusNode: editorFocusNode,
        readOnly: widget.readOnly,
        autofocus: widget.autofocus,
        maxLines: null,
        expands: true,
        decoration: InputDecoration.collapsed(
          hintText: l.hint_note,
        ),
        spellCheckConfiguration: SpellCheckConfiguration(
          spellCheckService: DefaultSpellCheckService(),
        ),
        onChanged: onChanged,
      ),
    );
  }
}
