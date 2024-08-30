import 'package:flutter/material.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';
import 'package:localmaterialnotes/common/constants/constants.dart';
import 'package:localmaterialnotes/common/preferences/preference_key.dart';
import 'package:localmaterialnotes/common/preferences/preferences_utils.dart';
import 'package:localmaterialnotes/pages/settings/widgets/custom_settings_list.dart';

/// Settings related to the notes editor.
class SettingsEditorPage extends StatefulWidget {
  const SettingsEditorPage({super.key});

  @override
  State<SettingsEditorPage> createState() => _SettingsEditorPageState();
}

class _SettingsEditorPageState extends State<SettingsEditorPage> {
  /// Toggles the setting to show the undo/redo buttons in the editor's app bar.
  void _toggleShowUndoRedoButtons(bool toggled) {
    setState(() {
      PreferencesUtils().set<bool>(PreferenceKey.showUndoRedoButtons, toggled);
    });
  }

  /// Toggles the setting to show the checklist button in the editor's app bar or toolbar.
  ///
  /// If the editor's toolbar is enabled, the checklist button is shown inside it.
  /// Otherwise, it's shown in the editor's app bar.
  void _toggleShowChecklistButton(bool toggled) {
    setState(() {
      PreferencesUtils().set<bool>(PreferenceKey.showChecklistButton, toggled);
    });
  }

  /// Toggles the setting to show the editor's toolbar.
  void _toggleShowToolbar(bool toggled) {
    setState(() {
      PreferencesUtils().set<bool>(PreferenceKey.showToolbar, toggled);
    });
  }

  /// Toggles the setting to use spacing between the paragraphs.
  void _toggleUseParagraphSpacing(bool toggled) {
    setState(() {
      PreferencesUtils().set<bool>(PreferenceKey.useParagraphsSpacing, toggled);
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool showUndoRedoButtons = PreferenceKey.showUndoRedoButtons.getPreferenceOrDefault<bool>();
    final bool showChecklistButton = PreferenceKey.showChecklistButton.getPreferenceOrDefault<bool>();
    final bool showToolbar = PreferenceKey.showToolbar.getPreferenceOrDefault<bool>();

    final bool useParagraphsSpacing = PreferenceKey.useParagraphsSpacing.getPreferenceOrDefault<bool>();

    return CustomSettingsList(
      sections: [
        SettingsSection(
          title: Text(localizations.settings_editor_formatting),
          tiles: [
            SettingsTile.switchTile(
              leading: const Icon(Icons.undo),
              title: Text(localizations.settings_show_undo_redo_buttons),
              description: Text(localizations.settings_show_undo_redo_buttons_description),
              initialValue: showUndoRedoButtons,
              onToggle: _toggleShowUndoRedoButtons,
            ),
            SettingsTile.switchTile(
              leading: const Icon(Icons.checklist),
              title: Text(localizations.settings_show_checklist_button),
              description: Text(localizations.settings_show_checklist_button_description),
              initialValue: showChecklistButton,
              onToggle: _toggleShowChecklistButton,
            ),
            SettingsTile.switchTile(
              leading: const Icon(Icons.format_paint),
              title: Text(localizations.settings_show_toolbar),
              description: Text(localizations.settings_show_toolbar_description),
              initialValue: showToolbar,
              onToggle: _toggleShowToolbar,
            ),
          ],
        ),
        SettingsSection(
          title: Text(localizations.settings_editor_appearance),
          tiles: [
            SettingsTile.switchTile(
              leading: const Icon(Icons.format_line_spacing),
              title: Text(localizations.settings_use_paragraph_spacing),
              description: Text(localizations.settings_use_paragraph_spacing_description),
              initialValue: useParagraphsSpacing,
              onToggle: _toggleUseParagraphSpacing,
            ),
          ],
        ),
      ],
    );
  }
}
