import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:settings_tiles/settings_tiles.dart';

import '../../../common/constants/constants.dart';
import '../../../common/constants/paddings.dart';
import '../../../common/navigation/app_bars/basic_app_bar.dart';
import '../../../common/navigation/top_navigation.dart';
import '../../../common/preferences/enums/confirmations.dart';
import '../../../common/preferences/enums/swipe_actions/archived_swipe_action.dart';
import '../../../common/preferences/enums/swipe_actions/available_swipe_action.dart';
import '../../../common/preferences/enums/swipe_actions/deleted_swipe_action.dart';
import '../../../common/preferences/preference_key.dart';

/// Settings related to the behavior of the application.
class SettingsBehaviorPage extends ConsumerStatefulWidget {
  /// Default constructor.
  const SettingsBehaviorPage({super.key});

  @override
  ConsumerState<SettingsBehaviorPage> createState() => _SettingsBehaviorPageState();
}

class _SettingsBehaviorPageState extends ConsumerState<SettingsBehaviorPage> {
  /// Asks the user to choose which confirmations should be shown.
  Future<void> submittedConfirmations(Confirmations confirmations) async {
    await PreferenceKey.confirmations.set(confirmations.name);

    setState(() {});
  }

  /// Sets the new available right [swipeAction].
  Future<void> submittedAvailableSwipeRightAction(AvailableSwipeAction swipeAction) async {
    await PreferenceKey.swipeRightAction.set(swipeAction.name);

    setState(() {});
  }

  /// Sets the new available left [swipeAction].
  Future<void> submittedAvailableSwipeLeftAction(AvailableSwipeAction swipeAction) async {
    await PreferenceKey.swipeLeftAction.set(swipeAction.name);

    setState(() {});
  }

  /// Sets the new archived right [swipeAction].
  Future<void> submittedArchivedSwipeRightAction(ArchivedSwipeAction swipeAction) async {
    await PreferenceKey.archivedSwipeRightAction.set(swipeAction.name);

    setState(() {});
  }

  /// Sets the new archived left [swipeAction].
  Future<void> submittedArchivedSwipeLeftAction(ArchivedSwipeAction swipeAction) async {
    await PreferenceKey.archivedSwipeLeftAction.set(swipeAction.name);

    setState(() {});
  }

  /// Sets the new deleted right [swipeAction].
  Future<void> submittedDeletedSwipeRightAction(DeletedSwipeAction swipeAction) async {
    await PreferenceKey.binSwipeRightAction.set(swipeAction.name);

    setState(() {});
  }

  /// Sets the new deleted left [swipeAction].
  Future<void> submittedDeletedSwipeLeftAction(DeletedSwipeAction swipeAction) async {
    await PreferenceKey.binSwipeLeftAction.set(swipeAction.name);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final confirmations = Confirmations.fromPreference();

    final availableSwipeActionsPreferences = (
      right: PreferenceKey.swipeRightAction.preferenceOrDefault,
      left: PreferenceKey.swipeLeftAction.preferenceOrDefault,
    );
    final availableSwipeActions = (
      right: AvailableSwipeAction.rightFromPreference(preference: availableSwipeActionsPreferences.right),
      left: AvailableSwipeAction.leftFromPreference(preference: availableSwipeActionsPreferences.left),
    );

    final archivedSwipeActions = (
      right: ArchivedSwipeAction.rightFromPreference(),
      left: ArchivedSwipeAction.leftFromPreference(),
    );

    final deletedSwipeActions = (
      right: DeletedSwipeAction.rightFromPreference(),
      left: DeletedSwipeAction.leftFromPreference(),
    );

    return Scaffold(
      appBar: TopNavigation(
        appbar: BasicAppBar(title: l.navigation_settings_behavior),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: Paddings.bottomSystemUi,
          child: Column(
            children: [
              SettingSection(
                divider: null,
                title: l.settings_behavior_application,
                tiles: [
                  SettingSingleOptionTile.detailed(
                    icon: Icons.warning,
                    title: l.settings_confirmations,
                    value: confirmations.title,
                    description: l.settings_confirmations_description,
                    dialogTitle: l.settings_confirmations,
                    options: Confirmations.values
                        .map(
                          (confirmation) => (
                            value: confirmation,
                            title: confirmation.title,
                            subtitle: null,
                          ),
                        )
                        .toList(),
                    initialOption: confirmations,
                    onSubmitted: submittedConfirmations,
                  ),
                ],
              ),
              SettingSection(
                divider: null,
                title: l.settings_behavior_swipe_actions,
                tiles: [
                  SettingSingleOptionTile.detailed(
                    icon: Icons.swipe_right,
                    title: l.settings_swipe_action_right,
                    value: availableSwipeActions.right.title,
                    description: l.settings_swipe_action_right_description,
                    dialogTitle: l.settings_swipe_action_right,
                    options: AvailableSwipeAction.settings
                        .map(
                          (swipeAction) => (
                            value: swipeAction,
                            title: swipeAction.title,
                            subtitle: null,
                          ),
                        )
                        .toList(),
                    initialOption: availableSwipeActions.right,
                    onSubmitted: submittedAvailableSwipeRightAction,
                  ),
                  SettingSingleOptionTile.detailed(
                    icon: Icons.swipe_left,
                    title: l.settings_swipe_action_left,
                    value: availableSwipeActions.left.title,
                    description: l.settings_swipe_action_left_description,
                    dialogTitle: l.settings_swipe_action_left,
                    options: AvailableSwipeAction.settings
                        .map(
                          (swipeAction) => (
                            value: swipeAction,
                            title: swipeAction.title,
                            subtitle: null,
                          ),
                        )
                        .toList(),
                    initialOption: availableSwipeActions.left,
                    onSubmitted: submittedAvailableSwipeLeftAction,
                  ),
                ],
              ),
              SettingSection(
                divider: null,
                title: l.settings_behavior_swipe_actions_archives,
                tiles: [
                  SettingSingleOptionTile.detailed(
                    icon: Icons.swipe_right,
                    title: l.settings_swipe_action_right,
                    value: archivedSwipeActions.right.title,
                    description: l.settings_swipe_action_right_description,
                    dialogTitle: l.settings_swipe_action_right,
                    options: ArchivedSwipeAction.values
                        .map(
                          (swipeAction) => (
                            value: swipeAction,
                            title: swipeAction.title,
                            subtitle: null,
                          ),
                        )
                        .toList(),
                    initialOption: archivedSwipeActions.right,
                    onSubmitted: submittedArchivedSwipeRightAction,
                  ),
                  SettingSingleOptionTile.detailed(
                    icon: Icons.swipe_left,
                    title: l.settings_swipe_action_left,
                    value: archivedSwipeActions.left.title,
                    description: l.settings_swipe_action_left_description,
                    dialogTitle: l.settings_swipe_action_left,
                    options: ArchivedSwipeAction.values
                        .map(
                          (swipeAction) => (
                            value: swipeAction,
                            title: swipeAction.title,
                            subtitle: null,
                          ),
                        )
                        .toList(),
                    initialOption: archivedSwipeActions.left,
                    onSubmitted: submittedArchivedSwipeLeftAction,
                  ),
                ],
              ),
              SettingSection(
                divider: null,
                title: l.settings_behavior_swipe_actions_bin,
                tiles: [
                  SettingSingleOptionTile.detailed(
                    icon: Icons.swipe_right,
                    title: l.settings_swipe_action_right,
                    value: deletedSwipeActions.right.title,
                    description: l.settings_bin_swipe_action_right_description,
                    dialogTitle: l.settings_swipe_action_right,
                    options: DeletedSwipeAction.values
                        .map(
                          (swipeAction) => (
                            value: swipeAction,
                            title: swipeAction.title,
                            subtitle: null,
                          ),
                        )
                        .toList(),
                    initialOption: deletedSwipeActions.right,
                    onSubmitted: submittedDeletedSwipeRightAction,
                  ),
                  SettingSingleOptionTile.detailed(
                    icon: Icons.swipe_left,
                    title: l.settings_swipe_action_left,
                    value: deletedSwipeActions.left.title,
                    description: l.settings_bin_swipe_action_left_description,
                    dialogTitle: l.settings_swipe_action_left,
                    options: DeletedSwipeAction.values
                        .map(
                          (swipeAction) => (
                            value: swipeAction,
                            title: swipeAction.title,
                            subtitle: null,
                          ),
                        )
                        .toList(),
                    initialOption: deletedSwipeActions.left,
                    onSubmitted: submittedDeletedSwipeLeftAction,
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
