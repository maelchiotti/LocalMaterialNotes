import 'package:fleather/fleather.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../common/constants/constants.dart';
import '../../../common/constants/paddings.dart';
import '../../../common/preferences/enums/font.dart';
import '../../../common/preferences/preference_key.dart';

/// Text field to edit the content of a note.
class EditorField extends StatelessWidget {
  /// Default constructor.
  const EditorField({
    super.key,
    required this.fleatherController,
    required this.readOnly,
    required this.autofocus,
  });

  /// Controller of the content text field.
  final FleatherController fleatherController;

  /// Whether the text fields are read only.
  final bool readOnly;

  /// Whether to automatically focus the content text field.
  final bool autofocus;

  /// Opens the [url].
  void _launchUrl(String? url) {
    if (url == null) {
      return;
    }

    launchUrl(Uri.parse(url));
  }

  @override
  Widget build(BuildContext context) {
    throw Exception("JAJ");
    final useParagraphsSpacing = PreferenceKey.useParagraphsSpacing.getPreferenceOrDefault();
    final editorFont = Font.editorFromPreference();

    final fleatherThemeFallback = FleatherThemeData.fallback(context);
    final fleatherThemeParagraph = TextBlockTheme(
      style: fleatherThemeFallback.paragraph.style.copyWith(fontFamily: editorFont.familyName),
      spacing: useParagraphsSpacing ? fleatherThemeFallback.paragraph.spacing : const VerticalSpacing.zero(),
    );

    return FleatherTheme(
      data: fleatherThemeFallback.copyWith(
        paragraph: fleatherThemeParagraph,
      ),
      child: FleatherEditor(
        controller: fleatherController,
        focusNode: editorFocusNode,
        autofocus: autofocus,
        readOnly: readOnly,
        expands: true,
        onLaunchUrl: _launchUrl,
        spellCheckConfiguration: SpellCheckConfiguration(
          spellCheckService: DefaultSpellCheckService(),
        ),
        padding: Paddings.bottomSystemUi,
      ),
    );
  }
}
