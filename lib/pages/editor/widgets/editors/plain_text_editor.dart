import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../common/constants/constants.dart';
import '../../../../common/constants/paddings.dart';
import '../../../../common/extensions/build_context_extension.dart';
import '../../../../models/note/note.dart';
import '../../../../models/note/note_status.dart';
import '../../../../providers/notes/notes_provider.dart';
import '../../../../providers/notifiers/notifiers.dart';

/// Plain text editor.
class PlainTextEditor extends ConsumerStatefulWidget {
  /// Text editor allowing to edit the plain text content of a [PlainTextNote].
  const PlainTextEditor({super.key, required this.note, required this.readOnly, required this.autofocus});

  /// The note to display.
  final PlainTextNote note;

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

  void onChanged(String content) {
    PlainTextNote note = widget.note..content = content;

    ref.read(notesProvider(status: NoteStatus.available, label: currentLabelFilter).notifier).edit(note);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Paddings.pageHorizontal,
      child: TextField(
        controller: contentTextController,
        focusNode: editorFocusNode,
        readOnly: widget.readOnly,
        autofocus: widget.autofocus,
        maxLines: null,
        expands: true,
        decoration: InputDecoration.collapsed(hintText: context.l.hint_content),
        spellCheckConfiguration: SpellCheckConfiguration(spellCheckService: DefaultSpellCheckService()),
        onChanged: onChanged,
      ),
    );
  }
}
