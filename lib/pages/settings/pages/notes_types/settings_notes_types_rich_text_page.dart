import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:settings_tiles/settings_tiles.dart';

import '../../../../common/constants/constants.dart';
import '../../../../common/constants/paddings.dart';
import '../../../../common/navigation/app_bars/basic_app_bar.dart';
import '../../../../common/navigation/top_navigation.dart';
import '../../../../common/preferences/preference_key.dart';
import '../../../../models/note/types/note_type.dart';

/// Rich text notes settings.
class SettingsNotesTypesRichTextPage extends ConsumerStatefulWidget {
  /// Settings page related to the rich text notes.
  const SettingsNotesTypesRichTextPage({super.key});

  @override
  ConsumerState<SettingsNotesTypesRichTextPage> createState() => _SettingsNotesTypesRichTextPageState();
}

class _SettingsNotesTypesRichTextPageState extends ConsumerState<SettingsNotesTypesRichTextPage> {
  /// Toggles the setting to use spacing between the paragraphs.
  void _toggleUseParagraphSpacing(bool toggled) {
    setState(() {
      PreferenceKey.useParagraphsSpacing.set(toggled);
    });
  }

  @override
  Widget build(BuildContext context) {
    final useParagraphsSpacing = PreferenceKey.useParagraphsSpacing.getPreferenceOrDefault();

    return Scaffold(
      appBar: TopNavigation(
        appbar: BasicAppBar(title: NoteType.richText.title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: Paddings.bottomSystemUi,
          child: Column(
            children: [
              SettingSection(
                divider: null,
                title: l.settings_section_rich_text_notes_appearance,
                tiles: [
                  SettingSwitchTile(
                    icon: Icons.format_line_spacing,
                    title: l.settings_use_paragraph_spacing,
                    description: l.settings_use_paragraph_spacing_description,
                    toggled: useParagraphsSpacing,
                    onChanged: _toggleUseParagraphSpacing,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
