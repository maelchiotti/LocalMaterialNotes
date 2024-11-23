import 'package:flag_secure/flag_secure.dart';
import 'package:flutter/material.dart';
import 'package:localmaterialnotes/common/constants/constants.dart';
import 'package:localmaterialnotes/common/constants/paddings.dart';
import 'package:localmaterialnotes/common/navigation/app_bars/basic_app_bar.dart';
import 'package:localmaterialnotes/common/navigation/top_navigation.dart';
import 'package:localmaterialnotes/common/preferences/enums/confirmations.dart';
import 'package:localmaterialnotes/common/preferences/enums/swipe_action.dart';
import 'package:localmaterialnotes/common/preferences/preference_key.dart';
import 'package:localmaterialnotes/providers/notifiers.dart';
import 'package:localmaterialnotes/utils/keys.dart';
import 'package:settings_tiles/settings_tiles.dart';

/// Settings related to the behavior of the application.
class SettingsBehaviorPage extends StatefulWidget {
  /// Default constructor.
  const SettingsBehaviorPage({super.key});

  @override
  State<SettingsBehaviorPage> createState() => _SettingsBehaviorPageState();
}

class _SettingsBehaviorPageState extends State<SettingsBehaviorPage> {
  /// Asks the user to choose which confirmations should be shown.
  void _submittedConfirmations(Confirmations confirmations) {
    setState(() {
      PreferenceKey.confirmations.set<String>(confirmations.name);
    });
  }

  /// Sets the new right [swipeAction].
  void _submittedSwipeRightAction(SwipeAction swipeAction) {
    setState(() {
      PreferenceKey.swipeRightAction.set<String>(swipeAction.name);
      swipeActionsNotifier.value = (right: swipeAction, left: swipeActionsNotifier.value.left);
    });
  }

  /// Sets the new left [swipeAction].
  void _submittedSwipeLeftAction(SwipeAction swipeAction) {
    setState(() {
      PreferenceKey.swipeLeftAction.set<String>(swipeAction.name);
      swipeActionsNotifier.value = (right: swipeActionsNotifier.value.right, left: swipeAction);
    });
  }

  /// Toggles Android's `FLAG_SECURE` to hide the app from the recent apps and prevent screenshots.
  Future<void> _setFlagSecure(bool toggled) async {
    setState(() {
      PreferenceKey.flagSecure.set<bool>(toggled);
    });

    toggled ? await FlagSecure.set() : await FlagSecure.unset();
  }

  @override
  Widget build(BuildContext context) {
    final confirmations = Confirmations.fromPreference();
    final flagSecure = PreferenceKey.flagSecure.getPreferenceOrDefault<bool>();

    final swipeRightAction = swipeActionsNotifier.value.right;
    final swipeLeftAction = swipeActionsNotifier.value.left;

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
                title: l.settings_behavior_application,
                tiles: [
                  SettingSingleOptionTile.detailed(
                    icon: Icons.warning,
                    title: l.settings_confirmations,
                    value: confirmations.title,
                    description: l.settings_confirmations_description,
                    dialogTitle: l.settings_confirmations,
                    options: Confirmations.values.map(
                      (confirmation) {
                        return (
                          value: confirmation,
                          title: confirmation.title,
                          subtitle: null,
                        );
                      },
                    ).toList(),
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
                    value: swipeRightAction.title(),
                    description: l.settings_swipe_action_right_description,
                    dialogTitle: l.settings_swipe_action_right,
                    options: SwipeAction.values.map(
                      (swipeAction) {
                        return (
                          value: swipeAction,
                          title: swipeAction.title(),
                          subtitle: null,
                        );
                      },
                    ).toList(),
                    initialOption: swipeRightAction,
                    onSubmitted: _submittedSwipeRightAction,
                  ),
                  SettingSingleOptionTile.detailed(
                    icon: Icons.swipe_left,
                    title: l.settings_swipe_action_left,
                    value: swipeLeftAction.title(),
                    description: l.settings_swipe_action_left_description,
                    dialogTitle: l.settings_swipe_action_left,
                    options: SwipeAction.values.map(
                      (swipeAction) {
                        return (
                          value: swipeAction,
                          title: swipeAction.title(),
                          subtitle: null,
                        );
                      },
                    ).toList(),
                    initialOption: swipeLeftAction,
                    onSubmitted: _submittedSwipeLeftAction,
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
