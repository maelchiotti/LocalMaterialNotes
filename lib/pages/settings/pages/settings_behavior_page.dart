import 'package:flag_secure/flag_secure.dart';
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
import '../../../common/preferences/watched_preferences.dart';
import '../../../providers/preferences/preferences_provider.dart';

/// Settings related to the behavior of the application.
class SettingsBehaviorPage extends ConsumerStatefulWidget {
  /// Default constructor.
  const SettingsBehaviorPage({super.key});

  @override
  ConsumerState<SettingsBehaviorPage> createState() => _SettingsBehaviorPageState();
}

class _SettingsBehaviorPageState extends ConsumerState<SettingsBehaviorPage> {
  /// Asks the user to choose which confirmations should be shown.
  void _submittedConfirmations(Confirmations confirmations) {
    setState(() {
      PreferenceKey.confirmations.set(confirmations.name);
    });
  }

  /// Sets the new available right [swipeAction].
  void _submittedAvailableSwipeRightAction(AvailableSwipeAction swipeAction) {
    PreferenceKey.swipeRightAction.set(swipeAction.name);

    ref.read(preferencesProvider.notifier).update(WatchedPreferences(availableSwipeRightAction: swipeAction));
  }

  /// Sets the new available left [swipeAction].
  void _submittedAvailableSwipeLeftAction(AvailableSwipeAction swipeAction) {
    PreferenceKey.swipeLeftAction.set(swipeAction.name);

    ref.read(preferencesProvider.notifier).update(WatchedPreferences(availableSwipeLeftAction: swipeAction));
  }

  /// Sets the new archived right [swipeAction].
  void _submittedArchivedSwipeRightAction(ArchivedSwipeAction swipeAction) {
    PreferenceKey.archivedSwipeRightAction.set(swipeAction.name);

    ref.read(preferencesProvider.notifier).update(WatchedPreferences(archivedSwipeRightAction: swipeAction));
  }

  /// Sets the new archived left [swipeAction].
  void _submittedArchivedSwipeLeftAction(ArchivedSwipeAction swipeAction) {
    PreferenceKey.archivedSwipeLeftAction.set(swipeAction.name);

    ref.read(preferencesProvider.notifier).update(WatchedPreferences(archivedSwipeLeftAction: swipeAction));
  }

  /// Sets the new deleted right [swipeAction].
  void _submittedDeletedSwipeRightAction(DeletedSwipeAction swipeAction) {
    PreferenceKey.binSwipeRightAction.set(swipeAction.name);

    ref.read(preferencesProvider.notifier).update(WatchedPreferences(deletedSwipeRightAction: swipeAction));
  }

  /// Sets the new deleted left [swipeAction].
  void _submittedDeletedSwipeLeftAction(DeletedSwipeAction swipeAction) {
    PreferenceKey.binSwipeLeftAction.set(swipeAction.name);

    ref.read(preferencesProvider.notifier).update(WatchedPreferences(deletedSwipeLeftAction: swipeAction));
  }

  /// Toggles Android's `FLAG_SECURE` to hide the app from the recent apps and prevent screenshots.
  Future<void> _setFlagSecure(bool toggled) async {
    setState(() {
      PreferenceKey.flagSecure.set(toggled);
    });

    toggled ? await FlagSecure.set() : await FlagSecure.unset();
  }

  @override
  Widget build(BuildContext context) {
    final confirmations = Confirmations.fromPreference();
    final flagSecure = PreferenceKey.flagSecure.getPreferenceOrDefault();

    final availableSwipeActions = ref.watch(
      preferencesProvider.select((preferences) => preferences.availableSwipeActions),
    );
    final archivedSwipeActions = ref.watch(
      preferencesProvider.select((preferences) => preferences.archivedSwipeActions),
    );
    final deletedSwipeActions = ref.watch(
      preferencesProvider.select((preferences) => preferences.deletedSwipeActions),
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
                    onSubmitted: _submittedConfirmations,
                  ),
                  SettingSwitchTile(
                    icon: Icons.security,
                    title: l.settings_flag_secure,
                    description: l.settings_flag_secure_description,
                    toggled: flagSecure,
                    onChanged: _setFlagSecure,
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
                    value: availableSwipeActions.right.title(false),
                    description: l.settings_swipe_action_right_description,
                    dialogTitle: l.settings_swipe_action_right,
                    options: AvailableSwipeAction.values
                        .map(
                          (swipeAction) => (
                            value: swipeAction,
                            title: swipeAction.title(false),
                            subtitle: null,
                          ),
                        )
                        .toList(),
                    initialOption: availableSwipeActions.right,
                    onSubmitted: _submittedAvailableSwipeRightAction,
                  ),
                  SettingSingleOptionTile.detailed(
                    icon: Icons.swipe_left,
                    title: l.settings_swipe_action_left,
                    value: availableSwipeActions.left.title(false),
                    description: l.settings_swipe_action_left_description,
                    dialogTitle: l.settings_swipe_action_left,
                    options: AvailableSwipeAction.values
                        .map(
                          (swipeAction) => (
                            value: swipeAction,
                            title: swipeAction.title(false),
                            subtitle: null,
                          ),
                        )
                        .toList(),
                    initialOption: availableSwipeActions.left,
                    onSubmitted: _submittedAvailableSwipeLeftAction,
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
                    onSubmitted: _submittedArchivedSwipeRightAction,
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
                    onSubmitted: _submittedArchivedSwipeLeftAction,
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
                    onSubmitted: _submittedDeletedSwipeRightAction,
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
                    onSubmitted: _submittedDeletedSwipeLeftAction,
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
