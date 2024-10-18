import 'package:flag_secure/flag_secure.dart';
import 'package:flutter/material.dart';
import 'package:localmaterialnotes/common/constants/constants.dart';
import 'package:localmaterialnotes/common/navigation/app_bars/basic_app_bar.dart';
import 'package:localmaterialnotes/common/navigation/top_navigation.dart';
import 'package:localmaterialnotes/common/preferences/enums/confirmations.dart';
import 'package:localmaterialnotes/common/preferences/enums/swipe_action.dart';
import 'package:localmaterialnotes/common/preferences/enums/swipe_direction.dart';
import 'package:localmaterialnotes/common/preferences/preference_key.dart';
import 'package:localmaterialnotes/common/preferences/preferences_utils.dart';
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
  Future<void> _selectConfirmations() async {
    final confirmationsPreference = Confirmations.fromPreference();

    await showAdaptiveDialog<Confirmations>(
      context: context,
      useRootNavigator: false,
      builder: (context) {
        return SimpleDialog(
          clipBehavior: Clip.hardEdge,
          title: Text(l.settings_confirmations),
          children: Confirmations.values.map((confirmationsValue) {
            return RadioListTile<Confirmations>(
              value: confirmationsValue,
              groupValue: confirmationsPreference,
              title: Text(confirmationsValue.title),
              selected: confirmationsPreference == confirmationsValue,
              onChanged: (confirmations) => Navigator.pop(context, confirmations),
            );
          }).toList(),
        );
      },
    ).then((confirmations) {
      if (confirmations == null) {
        return;
      }

      setState(() {
        PreferencesUtils().set<String>(PreferenceKey.confirmations, confirmations.name);
      });
    });
  }

  /// Asks the user to choose which action should be triggered when swiping the notes tiles in the [swipeDirection].
  Future<void> _selectSwipeAction(SwipeDirection swipeDirection) async {
    SwipeAction swipeActionPreference;
    switch (swipeDirection) {
      case SwipeDirection.right:
        swipeActionPreference = swipeActionsNotifier.value.$1;
      case SwipeDirection.left:
        swipeActionPreference = swipeActionsNotifier.value.$2;
    }

    await showAdaptiveDialog<SwipeAction>(
      context: context,
      useRootNavigator: false,
      builder: (context) {
        return SimpleDialog(
          clipBehavior: Clip.hardEdge,
          title: Text(
            swipeDirection == SwipeDirection.right ? l.settings_swipe_action_right : l.settings_swipe_action_left,
          ),
          children: SwipeAction.values.map((swipeAction) {
            return RadioListTile<SwipeAction>(
              value: swipeAction,
              groupValue: swipeActionPreference,
              title: Text(swipeAction.title()),
              selected: swipeActionPreference == swipeAction,
              onChanged: (swipeAction) => Navigator.pop(context, swipeAction),
            );
          }).toList(),
        );
      },
    ).then((swipeAction) {
      if (swipeAction == null) {
        return;
      }

      setState(() {
        switch (swipeDirection) {
          case SwipeDirection.right:
            PreferencesUtils().set<String>(PreferenceKey.swipeRightAction, swipeAction.name);
            swipeActionsNotifier.value = (swipeAction, swipeActionsNotifier.value.$2);
          case SwipeDirection.left:
            PreferencesUtils().set<String>(PreferenceKey.swipeLeftAction, swipeAction.name);
            swipeActionsNotifier.value = (swipeActionsNotifier.value.$1, swipeAction);
        }
      });
    });
  }

  /// Toggles Android's `FLAG_SECURE` to hide the app from the recent apps and prevent screenshots.
  Future<void> _setFlagSecure(bool toggled) async {
    setState(() {
      PreferencesUtils().set<bool>(PreferenceKey.flagSecure, toggled);
    });

    toggled ? await FlagSecure.set() : await FlagSecure.unset();
  }

  @override
  Widget build(BuildContext context) {
    final confirmations = Confirmations.fromPreference();
    final flagSecure = PreferenceKey.flagSecure.getPreferenceOrDefault<bool>();

    final swipeRightAction = swipeActionsNotifier.value.$1;
    final swipeLeftAction = swipeActionsNotifier.value.$2;

    return Scaffold(
      appBar: const TopNavigation(
        key: Keys.appBarSettingsMainSubpage,
        appbar: BasicAppBar.back(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SettingSection(
              divider: null,
              title: l.settings_behavior_application,
              tiles: [
                SettingActionTile(
                  icon: Icons.warning,
                  title: l.settings_confirmations,
                  value: confirmations.title,
                  description: l.settings_confirmations_description,
                  onTap: _selectConfirmations,
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
                SettingActionTile(
                  icon: Icons.swipe_right,
                  title: l.settings_swipe_action_right,
                  value: swipeRightAction.title(),
                  description: l.settings_swipe_action_right_description,
                  onTap: () => _selectSwipeAction(SwipeDirection.right),
                ),
                SettingActionTile(
                  icon: Icons.swipe_left,
                  title: l.settings_swipe_action_left,
                  value: swipeLeftAction.title(),
                  description: l.settings_swipe_action_left_description,
                  onTap: () => _selectSwipeAction(SwipeDirection.left),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
