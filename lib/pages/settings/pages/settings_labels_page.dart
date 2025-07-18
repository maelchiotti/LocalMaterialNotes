import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:settings_tiles/settings_tiles.dart';

import '../../../common/constants/paddings.dart';
import '../../../common/extensions/build_context_extension.dart';
import '../../../common/navigation/app_bars/basic_app_bar.dart';
import '../../../common/navigation/top_navigation.dart';
import '../../../common/preferences/enums/swipe_actions/label_swipe_action.dart';
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
  Future<void> toggleEnableLabels(bool toggled) async {
    await PreferenceKey.enableLabels.set(toggled);

    setState(() {});
  }

  /// Toggles whether to show the labels list in the editor.
  Future<void> toggleShowLabelsListOnNoteTile(bool toggled) async {
    await PreferenceKey.showLabelsListOnNoteTile.set(toggled);

    setState(() {});
  }

  /// Toggles whether to show the labels list in the editor.
  Future<void> toggleShowLabelsListInEditor(bool toggled) async {
    await PreferenceKey.showLabelsListInEditorPage.set(toggled);

    setState(() {});
  }

  /// Sets the new label right [swipeAction].
  Future<void> submittedLabelSwipeRightAction(LabelSwipeAction swipeAction) async {
    await PreferenceKey.labelSwipeRightAction.set(swipeAction.name);

    setState(() {});
  }

  /// Sets the new label left [swipeAction].
  Future<void> submittedLabelSwipeLeftAction(LabelSwipeAction swipeAction) async {
    await PreferenceKey.labelSwipeLeftAction.set(swipeAction.name);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isLabelsEnabled = PreferenceKey.enableLabels.preferenceOrDefault;
    final showLabelsListOnNoteTile = PreferenceKey.showLabelsListOnNoteTile.preferenceOrDefault;
    final showLabelsListInEditorPage = PreferenceKey.showLabelsListInEditorPage.preferenceOrDefault;

    final labelSwipeActionsPreferences = (
      right: PreferenceKey.labelSwipeRightAction.preferenceOrDefault,
      left: PreferenceKey.labelSwipeLeftAction.preferenceOrDefault,
    );
    final labelSwipeActions = (
      right: LabelSwipeAction.rightFromPreference(preference: labelSwipeActionsPreferences.right),
      left: LabelSwipeAction.leftFromPreference(preference: labelSwipeActionsPreferences.left),
    );

    return Scaffold(
      appBar: TopNavigation(appbar: BasicAppBar(title: context.l.navigation_settings_labels)),
      body: SingleChildScrollView(
        child: Padding(
          padding: Paddings.bottomSystemUi,
          child: Column(
            children: [
              SettingSection(
                tiles: [
                  SettingSwitchTile(
                    icon: SettingTileIcon(Icons.label),
                    title: Text(context.l.settings_enable_labels),
                    description: Text(context.l.settings_enable_labels_description),
                    toggled: isLabelsEnabled,
                    onChanged: toggleEnableLabels,
                  ),
                ],
              ),
              SettingSection(
                title: SettingSectionTitle(context.l.settings_labels_appearance),
                tiles: [
                  SettingSwitchTile(
                    enabled: isLabelsEnabled,
                    icon: SettingTileIcon(Symbols.tile_small),
                    title: Text(context.l.settings_show_labels_note_tile),
                    description: Text(context.l.settings_show_labels_note_tile_description),
                    toggled: showLabelsListOnNoteTile,
                    onChanged: toggleShowLabelsListOnNoteTile,
                  ),
                  SettingSwitchTile(
                    enabled: isLabelsEnabled,
                    icon: SettingTileIcon(Icons.edit),
                    title: Text(context.l.settings_show_labels_editor),
                    description: Text(context.l.settings_show_labels_editor_description),
                    toggled: showLabelsListInEditorPage,
                    onChanged: toggleShowLabelsListInEditor,
                  ),
                ],
              ),
              SettingSection(
                title: SettingSectionTitle(context.l.settings_labels_section_behavior),
                tiles: [
                  SettingSingleOptionTile.detailed(
                    icon: SettingTileIcon(Icons.swipe_right),
                    title: Text(context.l.settings_swipe_action_right),
                    value: SettingTileValue(labelSwipeActions.right.title(context)),
                    description: Text(context.l.settings_swipe_action_right_description),
                    dialogTitle: context.l.settings_swipe_action_right,
                    options: LabelSwipeAction.settings
                        .map((swipeAction) => (value: swipeAction, title: swipeAction.title(context), subtitle: null))
                        .toList(),
                    initialOption: labelSwipeActions.right,
                    onSubmitted: submittedLabelSwipeRightAction,
                  ),
                  SettingSingleOptionTile.detailed(
                    icon: SettingTileIcon(Icons.swipe_left),
                    title: Text(context.l.settings_swipe_action_left),
                    value: SettingTileValue(labelSwipeActions.left.title(context)),
                    description: Text(context.l.settings_swipe_action_left_description),
                    dialogTitle: context.l.settings_swipe_action_left,
                    options: LabelSwipeAction.settings
                        .map((swipeAction) => (value: swipeAction, title: swipeAction.title(context), subtitle: null))
                        .toList(),
                    initialOption: labelSwipeActions.left,
                    onSubmitted: submittedLabelSwipeLeftAction,
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
