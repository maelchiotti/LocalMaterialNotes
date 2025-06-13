import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:markdown/markdown.dart';

import '../../../../common/constants/constants.dart';
import '../../../../common/constants/paddings.dart';
import '../../../../common/extensions/build_context_extension.dart';
import '../../../../models/note/note.dart';
import '../../../../models/note/note_status.dart';
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

  void onChanged(String content) {
    MarkdownNote note = widget.note..content = content;

    ref.read(notesProvider(status: NoteStatus.available, label: currentLabelFilter).notifier).edit(note);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: Paddings.pageHorizontal,
      child: widget.readOnly && !widget.note.isContentEmpty
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
          : TextField(
              controller: contentTextController,
              focusNode: editorFocusNode,
              readOnly: widget.readOnly && widget.note.isContentEmpty,
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
