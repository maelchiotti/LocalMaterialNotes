import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:settings_tiles/settings_tiles.dart';

import '../../../common/constants/constants.dart';
import '../../../common/constants/paddings.dart';
import '../../../common/extensions/build_context_extension.dart';
import '../../../common/navigation/app_bars/basic_app_bar.dart';
import '../../../common/navigation/top_navigation.dart';
import '../../../common/preferences/enums/confirmations.dart';
import '../../../common/preferences/enums/swipe_actions/archived_swipe_action.dart';
import '../../../common/preferences/enums/swipe_actions/available_swipe_action.dart';
import '../../../common/preferences/enums/swipe_actions/deleted_swipe_action.dart';
import '../../../common/preferences/preference_key.dart';
import '../../../providers/notifiers/notifiers.dart';

/// Settings related to the behavior of the application.
class SettingsBehaviorPage extends ConsumerStatefulWidget {
  /// Default constructor.
  const SettingsBehaviorPage({super.key});

  @override
  ConsumerState<SettingsBehaviorPage> createState() => _SettingsBehaviorPageState();
}

class _SettingsBehaviorPageState extends ConsumerState<SettingsBehaviorPage> {
  /// Sets whether a confirmation is needed before exiting to [confirmBeforeExiting].
  Future<void> submittedConfirmBeforeExiting(bool confirmBeforeExiting) async {
    await PreferenceKey.confirmBeforeExiting.set(confirmBeforeExiting);

    canPopNotifier.update();

    setState(() {});
  }

  /// Sets which confirmations should be shown to [confirmations].
  Future<void> submittedConfirmations(Confirmations confirmations) async {
    await PreferenceKey.confirmations.set(confirmations.name);

    setState(() {});
  }

  /// Sets how often the bin should be automatically cleaned to [delay].
  Future<void> submittedAutoRemoveFromBin(double delay) async {
    await PreferenceKey.autoRemoveFromBinDelay.set(delay.toInt());

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
    final confirmBeforeExiting = PreferenceKey.confirmBeforeExiting.preferenceOrDefault;
    final confirmations = Confirmations.fromPreference();
    final autoRemoveFromBinDelay = PreferenceKey.autoRemoveFromBinDelay.preferenceOrDefault;

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
      appBar: TopNavigation(appbar: BasicAppBar(title: context.l.navigation_settings_behavior)),
      body: SingleChildScrollView(
        child: Padding(
          padding: Paddings.bottomSystemUi,
          child: Column(
            children: [
              SettingSection(
                divider: null,
                title: context.l.settings_behavior_application,
                tiles: [
                  SettingSwitchTile(
                    icon: Icons.exit_to_app,
                    title: context.l.settings_confirm_before_exiting_title,
                    description: context.l.settings_confirm_before_exiting_description,
                    toggled: confirmBeforeExiting,
                    onChanged: submittedConfirmBeforeExiting,
                  ),
                  SettingSingleOptionTile.detailed(
                    icon: Icons.warning,
                    title: context.l.settings_confirmations,
                    value: confirmations.title(context),
                    description: context.l.settings_confirmations_description,
                    dialogTitle: context.l.settings_confirmations,
                    options:
                        Confirmations.values
                            .map(
                              (confirmation) => (
                                value: confirmation,
                                title: confirmation.title(context),
                                subtitle: null,
                              ),
                            )
                            .toList(),
                    initialOption: confirmations,
                    onSubmitted: submittedConfirmations,
                  ),
                  SettingCustomSliderTile(
                    icon: Icons.auto_delete,
                    title: context.l.settings_auto_remove_from_bin_title,
                    value: context.l.settings_auto_remove_from_bin_value(autoRemoveFromBinDelay.toString()),
                    description: context.l.settings_auto_remove_from_bin_description,
                    dialogTitle: context.l.settings_auto_remove_from_bin_title,
                    label: (delay) => context.l.settings_auto_remove_from_bin_value(delay.toInt().toString()),
                    values: autoRemoveFromBinValues,
                    initialValue: autoRemoveFromBinDelay.toDouble(),
                    onSubmitted: submittedAutoRemoveFromBin,
                  ),
                ],
              ),
              SettingSection(
                divider: null,
                title: context.l.settings_behavior_swipe_actions,
                tiles: [
                  SettingSingleOptionTile.detailed(
                    icon: Icons.swipe_right,
                    title: context.l.settings_swipe_action_right,
                    value: availableSwipeActions.right.title(context),
                    description: context.l.settings_swipe_action_right_description,
                    dialogTitle: context.l.settings_swipe_action_right,
                    options:
                        AvailableSwipeAction.settings
                            .map(
                              (swipeAction) => (value: swipeAction, title: swipeAction.title(context), subtitle: null),
                            )
                            .toList(),
                    initialOption: availableSwipeActions.right,
                    onSubmitted: submittedAvailableSwipeRightAction,
                  ),
                  SettingSingleOptionTile.detailed(
                    icon: Icons.swipe_left,
                    title: context.l.settings_swipe_action_left,
                    value: availableSwipeActions.left.title(context),
                    description: context.l.settings_swipe_action_left_description,
                    dialogTitle: context.l.settings_swipe_action_left,
                    options:
                        AvailableSwipeAction.settings
                            .map(
                              (swipeAction) => (value: swipeAction, title: swipeAction.title(context), subtitle: null),
                            )
                            .toList(),
                    initialOption: availableSwipeActions.left,
                    onSubmitted: submittedAvailableSwipeLeftAction,
                  ),
                ],
              ),
              SettingSection(
                divider: null,
                title: context.l.settings_behavior_swipe_actions_archives,
                tiles: [
                  SettingSingleOptionTile.detailed(
                    icon: Icons.swipe_right,
                    title: context.l.settings_swipe_action_right,
                    value: archivedSwipeActions.right.title(context),
                    description: context.l.settings_swipe_action_right_description,
                    dialogTitle: context.l.settings_swipe_action_right,
                    options:
                        ArchivedSwipeAction.values
                            .map(
                              (swipeAction) => (value: swipeAction, title: swipeAction.title(context), subtitle: null),
                            )
                            .toList(),
                    initialOption: archivedSwipeActions.right,
                    onSubmitted: submittedArchivedSwipeRightAction,
                  ),
                  SettingSingleOptionTile.detailed(
                    icon: Icons.swipe_left,
                    title: context.l.settings_swipe_action_left,
                    value: archivedSwipeActions.left.title(context),
                    description: context.l.settings_swipe_action_left_description,
                    dialogTitle: context.l.settings_swipe_action_left,
                    options:
                        ArchivedSwipeAction.values
                            .map(
                              (swipeAction) => (value: swipeAction, title: swipeAction.title(context), subtitle: null),
                            )
                            .toList(),
                    initialOption: archivedSwipeActions.left,
                    onSubmitted: submittedArchivedSwipeLeftAction,
                  ),
                ],
              ),
              SettingSection(
                divider: null,
                title: context.l.settings_behavior_swipe_actions_bin,
                tiles: [
                  SettingSingleOptionTile.detailed(
                    icon: Icons.swipe_right,
                    title: context.l.settings_swipe_action_right,
                    value: deletedSwipeActions.right.title(context),
                    description: context.l.settings_bin_swipe_action_right_description,
                    dialogTitle: context.l.settings_swipe_action_right,
                    options:
                        DeletedSwipeAction.values
                            .map(
                              (swipeAction) => (value: swipeAction, title: swipeAction.title(context), subtitle: null),
                            )
                            .toList(),
                    initialOption: deletedSwipeActions.right,
                    onSubmitted: submittedDeletedSwipeRightAction,
                  ),
                  SettingSingleOptionTile.detailed(
                    icon: Icons.swipe_left,
                    title: context.l.settings_swipe_action_left,
                    value: deletedSwipeActions.left.title(context),
                    description: context.l.settings_bin_swipe_action_left_description,
                    dialogTitle: context.l.settings_swipe_action_left,
                    options:
                        DeletedSwipeAction.values
                            .map(
                              (swipeAction) => (value: swipeAction, title: swipeAction.title(context), subtitle: null),
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
