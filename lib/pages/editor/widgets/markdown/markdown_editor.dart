import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:markdown/markdown.dart';

import '../../../../common/constants/constants.dart';
import '../../../../common/constants/paddings.dart';
import '../../../../models/note/note.dart';
import '../../../../providers/notes/notes_provider.dart';
import '../../../../providers/notifiers/notifiers.dart';

/// Markdown editor.
class MarkdownEditor extends ConsumerStatefulWidget {
  /// Markdown allowing to edit the markdown text content of a [MarkdownNote].
  const MarkdownEditor({
    super.key,
    required this.note,
    required this.isNewNote,
    required this.readOnly,
    required this.autofocus,
  });

  /// The note to display.
  final MarkdownNote note;

  /// Whether the note was just created.
  final bool isNewNote;

  /// Whether the text fields are read only.
  final bool readOnly;

  /// Whether the text field should request focus.
  final bool autofocus;

  @override
  ConsumerState<MarkdownEditor> createState() => _MarkdownEditorState();
}

class _MarkdownEditorState extends ConsumerState<MarkdownEditor> {
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
    MarkdownNote note = widget.note..content = content;

    ref.read(notesProvider(label: currentLabelFilter).notifier).edit(note);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: Paddings.pageHorizontal,
      child: widget.readOnly
          ? Markdown(
              data: widget.note.content,
              padding: EdgeInsets.zero,
              selectable: true,
              extensionSet: ExtensionSet.gitHubFlavored,
              styleSheet: MarkdownStyleSheet.fromTheme(theme).copyWith(
                blockquoteDecoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(2.0),
                ),
                codeblockDecoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(2.0),
                ),
              ),
            )
          : Focus(
              onFocusChange: onFocusChange,
              child: TextField(
                controller: contentTextController,
                focusNode: editorFocusNode,
                readOnly: widget.readOnly,
                autofocus: widget.autofocus,
                maxLines: null,
                expands: true,
                decoration: InputDecoration.collapsed(hintText: ''),
                spellCheckConfiguration: SpellCheckConfiguration(
                  spellCheckService: DefaultSpellCheckService(),
                ),
                onChanged: onChanged,
              ),
            ),
    );
  }
}
