import 'package:flutter/material.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';
import 'package:localmaterialnotes/common/constants/constants.dart';
import 'package:localmaterialnotes/common/navigation/app_bars/basic_app_bar.dart';
import 'package:localmaterialnotes/common/navigation/top_navigation.dart';
import 'package:localmaterialnotes/common/preferences/preference_key.dart';
import 'package:localmaterialnotes/common/preferences/preferences_utils.dart';
import 'package:localmaterialnotes/pages/settings/widgets/custom_settings_list.dart';
import 'package:localmaterialnotes/utils/keys.dart';

/// Settings related to the notes editor.
class SettingsEditorPage extends StatefulWidget {
  /// Default constructor.
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

  /// Toggles the setting to use the editor mode button.
  void _toggleShowEditorModeButton(bool toggled) {
    setState(() {
      PreferencesUtils().set<bool>(PreferenceKey.editorModeButton, toggled);
    });
  }

  /// Toggles the setting to open the editor in reading mode by default.
  void _toggleOpenEditorInReadMode(bool toggled) {
    setState(() {
      PreferencesUtils().set<bool>(PreferenceKey.openEditorReadingMode, toggled);
    });
  }

  /// Toggles the setting to use spacing between the paragraphs.
  void _toggleFocusTitleOnNewNote(bool toggled) {
    setState(() {
      PreferencesUtils().set<bool>(PreferenceKey.focusTitleOnNewNote, toggled);
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
    final showUndoRedoButtons = PreferenceKey.showUndoRedoButtons.getPreferenceOrDefault<bool>();
    final showChecklistButton = PreferenceKey.showChecklistButton.getPreferenceOrDefault<bool>();
    final showToolbar = PreferenceKey.showToolbar.getPreferenceOrDefault<bool>();

    final showEditorModeButton = PreferenceKey.editorModeButton.getPreferenceOrDefault<bool>();
    final openEditorInReadMode = PreferenceKey.openEditorReadingMode.getPreferenceOrDefault<bool>();
    final focusTitleOnNewNote = PreferenceKey.focusTitleOnNewNote.getPreferenceOrDefault<bool>();

    final useParagraphsSpacing = PreferenceKey.useParagraphsSpacing.getPreferenceOrDefault<bool>();

    return Scaffold(
      appBar: const TopNavigation(
        key: Keys.appBarSettingsMainSubpage,
        appbar: BasicAppBar.back(),
      ),
      body: CustomSettingsList(
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
            title: Text(localizations.settings_editor_behavior),
            tiles: [
              SettingsTile.switchTile(
                leading: const Icon(Icons.edit),
                title: Text(localizations.settings_show_editor_mode_button),
                description: Text(localizations.settings_show_editor_mode_button_description),
                initialValue: showEditorModeButton,
                onToggle: _toggleShowEditorModeButton,
              ),
              SettingsTile.switchTile(
                enabled: showEditorModeButton,
                leading: const Icon(Icons.visibility),
                title: Text(localizations.settings_open_editor_reading_mode),
                description: Text(localizations.settings_open_editor_reading_mode_description),
                initialValue: openEditorInReadMode,
                onToggle: _toggleOpenEditorInReadMode,
              ),
              SettingsTile.switchTile(
                leading: const Icon(Icons.filter_center_focus),
                title: Text(localizations.settings_focus_title_on_new_note),
                description: Text(localizations.settings_focus_title_on_new_note_description),
                initialValue: focusTitleOnNewNote,
                onToggle: _toggleFocusTitleOnNewNote,
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
      ),
    );
  }
}
