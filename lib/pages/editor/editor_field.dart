import 'package:fleather/fleather.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localmaterialnotes/utils/constants/constants.dart';
import 'package:localmaterialnotes/utils/constants/paddings.dart';
import 'package:url_launcher/url_launcher_string.dart';

class EditorField extends StatelessWidget {
  const EditorField({
    super.key,
    required this.fleatherController,
    required this.readOnly,
    required this.autofocus,
  });

  final FleatherController fleatherController;
  final bool readOnly;
  final bool autofocus;

  void _launchUrl(String? url) {
    if (url == null) {
      return;
    }

    launchUrlString(url);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fleatherThemeFallback = FleatherThemeData.fallback(context);

    // TODO: remove when colors are fixed
    // cf. https://github.com/fleather-editor/fleather/issues/363
    return FleatherTheme(
      data: fleatherThemeFallback.copyWith(
        inlineCode: InlineCodeThemeData(
          // Changed
          backgroundColor: theme.colorScheme.surfaceContainerHigh,
          radius: fleatherThemeFallback.inlineCode.radius,
          style: fleatherThemeFallback.inlineCode.style.copyWith(
            color: theme.colorScheme.primary, // Changed
          ),
          heading1: fleatherThemeFallback.inlineCode.heading1,
          heading2: fleatherThemeFallback.inlineCode.heading2,
          heading3: fleatherThemeFallback.inlineCode.heading3,
        ),
        code: TextBlockTheme(
          decoration: fleatherThemeFallback.code.decoration!.copyWith(
            color: theme.colorScheme.surfaceContainerHigh, // Changed
          ),
          style: fleatherThemeFallback.code.style.copyWith(
            color: theme.colorScheme.primary, // Changed
          ),
          spacing: fleatherThemeFallback.code.spacing,
        ),
      ),
      child: FleatherField(
        controller: fleatherController,
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
        padding: Paddings.custom.bottomSystemUi,
      ),
    );
  }
}
