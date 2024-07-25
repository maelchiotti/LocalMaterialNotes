import 'package:flutter/material.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';
import 'package:localmaterialnotes/utils/constants/constants.dart';
import 'package:localmaterialnotes/utils/preferences/preference_key.dart';
import 'package:localmaterialnotes/utils/preferences/preferences_utils.dart';

/// Settings related to the notes editor.
class EditorSection extends AbstractSettingsSection {
  const EditorSection(this.updateState, {super.key});

  /// Triggers an update of the screen.
  final Function() updateState;

  /// Toggles the setting to show the undo/redo buttons in the editor's app bar.
  void _toggleShowUndoRedoButtons(bool toggled) {
    PreferencesUtils().set<bool>(PreferenceKey.showUndoRedoButtons.name, toggled);

    updateState();
  }

  /// Toggles the setting to show the checklist button in the editor's app bar or toolbar.
  ///
  /// If the editor's toolbar is enabled, the checklist button is shown inside it.
  /// Otherwise, it's shown in the editor's app bar.
  void _toggleShowChecklistButton(bool toggled) {
    PreferencesUtils().set<bool>(PreferenceKey.showChecklistButton.name, toggled);

    updateState();
  }

  /// Toggles the setting to show the editor's toolbar.
  void _toggleShowToolbar(bool toggled) {
    PreferencesUtils().set<bool>(PreferenceKey.showToolbar.name, toggled);

    updateState();
  }

  @override
  Widget build(BuildContext context) {
    final bool showUndoRedoButtons = PreferenceKey.showUndoRedoButtons.getPreferenceOrDefault<bool>();
    final bool showChecklistButton = PreferenceKey.showChecklistButton.getPreferenceOrDefault<bool>();
    final bool showToolbar = PreferenceKey.showToolbar.getPreferenceOrDefault<bool>();

    return SettingsSection(
      title: Text(localizations.settings_editor),
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
    );
  }
}
