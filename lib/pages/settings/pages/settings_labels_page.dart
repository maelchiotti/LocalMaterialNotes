import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:localmaterialnotes/common/constants/paddings.dart';
import 'package:localmaterialnotes/common/navigation/app_bars/basic_app_bar.dart';
import 'package:localmaterialnotes/common/navigation/top_navigation.dart';
import 'package:localmaterialnotes/common/preferences/preference_key.dart';
import 'package:localmaterialnotes/common/preferences/preferences_utils.dart';
import 'package:localmaterialnotes/utils/keys.dart';
import 'package:restart_app/restart_app.dart';
import 'package:settings_tiles/settings_tiles.dart';

/// Settings related to the labels.
class SettingsLabelsPage extends StatefulWidget {
  /// Default constructor.
  const SettingsLabelsPage({super.key});

  @override
  State<SettingsLabelsPage> createState() => _SettingsLabelsPageState();
}

class _SettingsLabelsPageState extends State<SettingsLabelsPage> {
  /// Toggles whether to enable the labels.
  Future<void> _toggleEnableLabels(bool toggled) async {
    setState(() {
      PreferencesUtils().set<bool>(PreferenceKey.enableLabels, toggled);
    });

    // The Restart package crashes the app if used in debug mode
    if (kReleaseMode) {
      await Restart.restartApp();
    }
  }

  /// Toggles whether to show the labels list in the editor.
  Future<void> _toggleShowLabelsListOnNoteTile(bool toggled) async {
    setState(() {
      PreferencesUtils().set<bool>(PreferenceKey.showLabelsListOnNoteTile, toggled);
    });
  }

  /// Toggles whether to show the labels list in the editor.
  Future<void> _toggleShowLabelsListInEditor(bool toggled) async {
    setState(() {
      PreferencesUtils().set<bool>(PreferenceKey.showLabelsListInEditorPage, toggled);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLabelsEnabled = PreferenceKey.enableLabels.getPreferenceOrDefault<bool>();
    final showLabelsListOnNoteTile = PreferenceKey.showLabelsListOnNoteTile.getPreferenceOrDefault<bool>();
    final showLabelsListInEditorPage = PreferenceKey.showLabelsListInEditorPage.getPreferenceOrDefault<bool>();

    return Scaffold(
      appBar: const TopNavigation(
        key: Keys.appBarSettingsMainSubpage,
        appbar: BasicAppBar.back(),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: Paddings.bottomSystemUi,
          child: Column(
            children: [
              SettingSection(
                divider: null,
                tiles: [
                  SettingSwitchTile(
                    icon: Icons.label,
                    title: 'Enable',
                    description: 'Allow to categorize the notes with labels',
                    toggled: isLabelsEnabled,
                    onChanged: _toggleEnableLabels,
                  ),
                ],
              ),
              SettingSection(
                divider: null,
                title: 'Appearance',
                tiles: [
                  SettingSwitchTile(
                    title: 'Show list on note tile',
                    description: 'Show the list of labels of the note tiles',
                    toggled: showLabelsListOnNoteTile,
                    onChanged: _toggleShowLabelsListOnNoteTile,
                  ),
                  SettingSwitchTile(
                    icon: Icons.edit,
                    title: 'Show list in editor',
                    description: 'Show the list of labels at the bottom of the editor',
                    toggled: showLabelsListInEditorPage,
                    onChanged: _toggleShowLabelsListInEditor,
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
