import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:restart_app/restart_app.dart';
import 'package:settings_tiles/settings_tiles.dart';

import '../../../common/constants/constants.dart';
import '../../../common/constants/paddings.dart';
import '../../../common/navigation/app_bars/basic_app_bar.dart';
import '../../../common/navigation/top_navigation.dart';
import '../../../common/preferences/preference_key.dart';

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
    await PreferenceKey.enableLabels.set(toggled);

    setState(() {});

    // The Restart package crashes the app if used in debug mode
    if (kReleaseMode) {
      await Restart.restartApp();
    }
  }

  /// Toggles whether to show the labels list in the editor.
  Future<void> _toggleShowLabelsListOnNoteTile(bool toggled) async {
    await PreferenceKey.showLabelsListOnNoteTile.set(toggled);

    setState(() {});
  }

  /// Toggles whether to show the labels list in the editor.
  Future<void> _toggleShowLabelsListInEditor(bool toggled) async {
    await PreferenceKey.showLabelsListInEditorPage.set(toggled);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isLabelsEnabled = PreferenceKey.enableLabels.preferenceOrDefault;
    final showLabelsListOnNoteTile = PreferenceKey.showLabelsListOnNoteTile.preferenceOrDefault;
    final showLabelsListInEditorPage = PreferenceKey.showLabelsListInEditorPage.preferenceOrDefault;

    return Scaffold(
      appBar: TopNavigation(
        appbar: BasicAppBar(title: l.navigation_settings_labels),
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
                    title: l.settings_enable_labels,
                    description: l.settings_enable_labels_description,
                    toggled: isLabelsEnabled,
                    onChanged: _toggleEnableLabels,
                  ),
                ],
              ),
              SettingSection(
                divider: null,
                title: l.settings_labels_appearance,
                tiles: [
                  SettingSwitchTile(
                    enabled: isLabelsEnabled,
                    icon: Symbols.tile_small,
                    title: l.settings_show_labels_note_tile,
                    description: l.settings_show_labels_note_tile_description,
                    toggled: showLabelsListOnNoteTile,
                    onChanged: _toggleShowLabelsListOnNoteTile,
                  ),
                  SettingSwitchTile(
                    enabled: isLabelsEnabled,
                    icon: Icons.edit,
                    title: l.settings_show_labels_editor,
                    description: l.settings_show_labels_editor_description,
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
