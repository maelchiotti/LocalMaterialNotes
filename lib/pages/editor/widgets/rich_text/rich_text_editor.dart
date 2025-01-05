import 'dart:convert';

import 'package:fleather/fleather.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../common/constants/constants.dart';
import '../../../../common/constants/paddings.dart';
import '../../../../common/preferences/enums/font.dart';
import '../../../../common/preferences/preference_key.dart';
import '../../../../models/note/note.dart';
import '../../../../providers/notes/notes_provider.dart';
import '../../../../providers/notifiers/notifiers.dart';

/// Text field to edit the content of a note.
class RichTextEditor extends ConsumerStatefulWidget {
  /// Default constructor.
  const RichTextEditor({
    super.key,
    required this.fleatherController,
    required this.note,
    required this.isNewNote,
    required this.readOnly,
    required this.autofocus,
  });

  final RichTextNote note;

  final FleatherController fleatherController;

  final bool isNewNote;

  /// Whether the text fields are read only.
  final bool readOnly;

  /// Whether this is a new note.
  final bool autofocus;

  @override
  ConsumerState<RichTextEditor> createState() => _RichTextEditorState();
}

class _RichTextEditorState extends ConsumerState<RichTextEditor> {
  @override
  void initState() {
    super.initState();

    // If this is a new note, force the editing mode
    if (widget.isNewNote) {
      isEditorInEditModeNotifier.value = true;
    }
  }

  void onFocusChange(bool hasFocus) {
    editorHasFocusNotifier.value = hasFocus;
  }

  /// Opens the [url].
  void launchUrl(String? url) {
    if (url == null) {
      return;
    }

    launchUrl(url);
  }

  /// Saves the new content of the [note] in the database.
  ///
  /// Also updates whether the undo/redo actions can be used.
  void onChanged(RichTextNote note) {
    fleatherControllerCanUndoNotifier.value = widget.fleatherController.canUndo;
    fleatherControllerCanRedoNotifier.value = widget.fleatherController.canRedo;

    note.content = jsonEncode(widget.fleatherController.document.toDelta().toJson());

    ref.read(notesProvider.notifier).edit(note);
  }

  @override
  Widget build(BuildContext context) {
    final useParagraphsSpacing = PreferenceKey.useParagraphsSpacing.getPreferenceOrDefault();
    final editorFont = Font.editorFromPreference();

    final fleatherThemeFallback = FleatherThemeData.fallback(context);
    final fleatherThemeParagraph = TextBlockTheme(
      style: fleatherThemeFallback.paragraph.style.copyWith(fontFamily: editorFont.familyName),
      spacing: useParagraphsSpacing ? fleatherThemeFallback.paragraph.spacing : const VerticalSpacing.zero(),
    );

    widget.fleatherController.addListener(() => onChanged(widget.note));

    return Focus(
      onFocusChange: onFocusChange,
      child: FleatherTheme(
        data: fleatherThemeFallback.copyWith(
          paragraph: fleatherThemeParagraph,
        ),
        child: FleatherField(
          controller: widget.fleatherController,
          focusNode: editorFocusNode,
          readOnly: widget.readOnly,
          autofocus: widget.autofocus,
          expands: true,
          decoration: InputDecoration.collapsed(
            hintText: l.hint_note,
          ),
          onLaunchUrl: launchUrl,
          spellCheckConfiguration: SpellCheckConfiguration(
            spellCheckService: DefaultSpellCheckService(),
          ),
          padding: Paddings.bottomSystemUi,
        ),
      ),
    );
  }
}
