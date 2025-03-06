import 'package:flutter/material.dart';
import 'package:settings_tiles/settings_tiles.dart';

import '../../../common/constants/constants.dart';
import '../../../common/constants/paddings.dart';
import '../../../common/navigation/app_bars/basic_app_bar.dart';
import '../../../common/navigation/top_navigation.dart';
import '../../../common/preferences/preference_key.dart';

/// Settings related to the notes editor.
class SettingsEditorPage extends StatefulWidget {
  /// Default constructor.
  const SettingsEditorPage({super.key});

  @override
  State<SettingsEditorPage> createState() => _SettingsEditorPageState();
}

class _SettingsEditorPageState extends State<SettingsEditorPage> {
  /// Toggles the setting to use the editor mode button.
  Future<void> _toggleShowEditorModeButton(bool toggled) async {
    await PreferenceKey.editorModeButton.set(toggled);

    setState(() {});
  }

  /// Toggles the setting to open the editor in reading mode by default.
  Future<void> _toggleOpenEditorInReadMode(bool toggled) async {
    await PreferenceKey.openEditorReadingMode.set(toggled);

    setState(() {});
  }

  /// Toggles the setting to use spacing between the paragraphs.
  Future<void> _toggleFocusTitleOnNewNote(bool toggled) async {
    await PreferenceKey.focusTitleOnNewNote.set(toggled);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final showEditorModeButton = PreferenceKey.editorModeButton.preferenceOrDefault;
    final openEditorInReadMode = PreferenceKey.openEditorReadingMode.preferenceOrDefault;
    final focusTitleOnNewNote = PreferenceKey.focusTitleOnNewNote.preferenceOrDefault;

    return Scaffold(
      appBar: TopNavigation(appbar: BasicAppBar(title: l.navigation_settings_editor)),
      body: SingleChildScrollView(
        child: Padding(
          padding: Paddings.bottomSystemUi,
          child: Column(
            children: [
              SettingSection(
                divider: null,
                title: l.settings_editor_behavior,
                tiles: [
                  SettingSwitchTile(
                    icon: Icons.edit,
                    title: l.settings_show_editor_mode_button,
                    description: l.settings_show_editor_mode_button_description,
                    toggled: showEditorModeButton,
                    onChanged: _toggleShowEditorModeButton,
                  ),
                  SettingSwitchTile(
                    enabled: showEditorModeButton,
                    icon: Icons.visibility,
                    title: l.settings_open_editor_reading_mode,
                    description: l.settings_open_editor_reading_mode_description,
                    toggled: openEditorInReadMode,
                    onChanged: _toggleOpenEditorInReadMode,
                  ),
                  SettingSwitchTile(
                    icon: Icons.filter_center_focus,
                    title: l.settings_focus_title_on_new_note,
                    description: l.settings_focus_title_on_new_note_description,
                    toggled: focusTitleOnNewNote,
                    onChanged: _toggleFocusTitleOnNewNote,
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
