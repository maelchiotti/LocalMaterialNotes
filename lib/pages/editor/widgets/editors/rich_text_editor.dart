import 'dart:convert';

import 'package:fleather/fleather.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../common/constants/constants.dart';
import '../../../../common/constants/paddings.dart';
import '../../../../common/extensions/build_context_extension.dart';
import '../../../../common/preferences/enums/font.dart';
import '../../../../common/preferences/preference_key.dart';
import '../../../../models/note/note.dart';
import '../../../../models/note/note_status.dart';
import '../../../../providers/notes/notes_provider.dart';
import '../../../../providers/notifiers/notifiers.dart';

/// Rich text editor.
class RichTextEditor extends ConsumerStatefulWidget {
  /// Text editor allowing to edit the rich text content of a [RichTextNote].
  const RichTextEditor({
    super.key,
    required this.fleatherController,
    required this.note,
    required this.readOnly,
    required this.autofocus,
  });

  /// The note to display.
  final RichTextNote note;

  /// The controller of the Fleather text field.
  final FleatherController fleatherController;

  /// Whether the text fields are read only.
  final bool readOnly;

  /// Whether the text field should request focus.
  final bool autofocus;

  @override
  ConsumerState<RichTextEditor> createState() => _RichTextEditorState();
}

class _RichTextEditorState extends ConsumerState<RichTextEditor> {
  void onLaunchUrl(String? url) {
    if (url == null) {
      return;
    }

    final uri = Uri.tryParse(url);
    if (uri == null) {
      logger.w('The URL opened in the rich text editor could not be parsed: $url');

      return;
    }

    launchUrl(uri);
  }

  void onChanged() {
    fleatherControllerCanUndoNotifier.value = widget.fleatherController.canUndo;
    fleatherControllerCanRedoNotifier.value = widget.fleatherController.canRedo;

    RichTextNote note = widget.note..content = jsonEncode(widget.fleatherController.document.toJson());

    ref.read(notesProvider(status: NoteStatus.available, label: currentLabelFilter).notifier).edit(note);
  }

  @override
  Widget build(BuildContext context) {
    final useParagraphsSpacing = PreferenceKey.useParagraphsSpacing.preferenceOrDefault;
    final editorFont = Font.editorFromPreference();

    widget.fleatherController.addListener(() => onChanged());

    final linkColor = Theme.brightnessOf(context) == Brightness.light ? Colors.blue[800] : Colors.blue[200];

    return Padding(
      padding: Paddings.pageHorizontal,
      child: DefaultTextStyle.merge(
        style: TextStyle(fontFamily: editorFont.familyName),
        child: Builder(
          builder: (context) {
            final fleatherThemeFallback = FleatherThemeData.fallback(context);
            final fleatherTheme = fleatherThemeFallback.copyWith(
              paragraph: !useParagraphsSpacing
                  ? TextBlockTheme(style: fleatherThemeFallback.paragraph.style, spacing: const VerticalSpacing.zero())
                  : null,
              link: fleatherThemeFallback.link.copyWith(color: linkColor, decorationColor: linkColor),
            );

            return FleatherTheme(
              data: fleatherTheme,
              child: FleatherField(
                controller: widget.fleatherController,
                focusNode: editorFocusNode,
                autofocus: widget.autofocus,
                readOnly: widget.readOnly,
                expands: true,
                onLaunchUrl: onLaunchUrl,
                decoration: InputDecoration.collapsed(hintText: context.l.hint_content),
                spellCheckConfiguration: SpellCheckConfiguration(spellCheckService: DefaultSpellCheckService()),
                padding: Paddings.bottomSystemUi,
              ),
            );
          },
        ),
      ),
    );
  }
}
