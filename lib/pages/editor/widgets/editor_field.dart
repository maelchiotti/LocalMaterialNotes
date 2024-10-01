import 'package:fleather/fleather.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localmaterialnotes/common/constants/constants.dart';
import 'package:localmaterialnotes/common/constants/paddings.dart';
import 'package:localmaterialnotes/common/preferences/preference_key.dart';
import 'package:url_launcher/url_launcher.dart';

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

  /// Whether the text fields should be read only.
  final bool readOnly;

  /// Whether to automatically focus the content text field.
  final bool autofocus;

  /// Opens the [url].
  void _launchUrl(String? url) {
    if (url == null) {
      return;
    }

    // Force the https scheme to handle the case where the URL does not contain 'http://' or 'https://' at the beginning
    final uri = Uri(scheme: 'https', path: url);

    launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    final fleatherField = FleatherField(
      controller: fleatherController,
      focusNode: editorFocusNode,
      autofocus: autofocus,
      readOnly: readOnly,
      expands: true,
      decoration: InputDecoration.collapsed(
        hintText: localizations.hint_note,
      ),
      onLaunchUrl: _launchUrl,
      spellCheckConfiguration: SpellCheckConfiguration(
        spellCheckService: DefaultSpellCheckService(),
      ),
      padding: Paddings.bottomSystemUi,
    );

    // If paragraph spacing should be used, return the editor directly without modifying its default theme
    if (PreferenceKey.useParagraphsSpacing.getPreferenceOrDefault<bool>()) {
      return fleatherField;
    }

    final fleatherThemeFallback = FleatherThemeData.fallback(context);

    return FleatherTheme(
      data: fleatherThemeFallback.copyWith(
        paragraph: TextBlockTheme(
          style: fleatherThemeFallback.paragraph.style,
          spacing: const VerticalSpacing.zero(),
        ),
      ),
      child: fleatherField,
    );
  }
}
