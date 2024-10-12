import 'package:flag_secure/flag_secure.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';
import 'package:localmaterialnotes/common/constants/constants.dart';
import 'package:localmaterialnotes/common/preferences/enums/confirmations.dart';
import 'package:localmaterialnotes/common/preferences/enums/swipe_action.dart';
import 'package:localmaterialnotes/common/preferences/enums/swipe_direction.dart';
import 'package:localmaterialnotes/common/preferences/preference_key.dart';
import 'package:localmaterialnotes/common/preferences/preferences_utils.dart';
import 'package:localmaterialnotes/pages/settings/widgets/custom_settings_list.dart';
import 'package:localmaterialnotes/pages/settings/widgets/setting_value_text.dart';
import 'package:localmaterialnotes/providers/notifiers.dart';

import '../../../common/widgets/navigation/app_bars/basic_app_bar.dart';
import '../../../common/widgets/navigation/top_navigation.dart';
import '../../../utils/keys.dart';

/// Settings related to the behavior of the application.
class SettingsBehaviorPage extends StatefulWidget {
  /// Default constructor.
  const SettingsBehaviorPage({super.key});

  @override
  State<SettingsBehaviorPage> createState() => _SettingsBehaviorPageState();
}

class _SettingsBehaviorPageState extends State<SettingsBehaviorPage> {
  /// Asks the user to choose which confirmations should be shown.
  Future<void> _selectConfirmations(BuildContext context) async {
    final confirmationsPreference = Confirmations.fromPreference();

    await showAdaptiveDialog<Confirmations>(
      context: context,
      useRootNavigator: false,
      builder: (context) {
        return SimpleDialog(
          clipBehavior: Clip.hardEdge,
          title: Text(localizations.settings_confirmations),
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
  Future<void> _selectSwipeAction(BuildContext context, SwipeDirection swipeDirection) async {
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
            swipeDirection == SwipeDirection.right
                ? localizations.settings_swipe_action_right
                : localizations.settings_swipe_action_left,
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
      body: CustomSettingsList(
        sections: [
          SettingsSection(
            title: Text(localizations.settings_behavior_application),
            tiles: [
              SettingsTile.navigation(
                leading: const Icon(Icons.warning),
                title: Text(localizations.settings_confirmations),
                value: SettingNavigationTileBody(
                  value: confirmations.title,
                  description: localizations.settings_confirmations_description,
                ),
                onPressed: _selectConfirmations,
              ),
              SettingsTile.switchTile(
                leading: const Icon(Icons.security),
                title: Text(localizations.settings_flag_secure),
                description: Text(localizations.settings_flag_secure_description),
                initialValue: flagSecure,
                onToggle: _setFlagSecure,
              ),
            ],
          ),
          SettingsSection(
            title: Text(localizations.settings_behavior_swipe_actions),
            tiles: [
              SettingsTile.navigation(
                leading: const Icon(Icons.swipe_right),
                title: Text(localizations.settings_swipe_action_right),
                value: SettingNavigationTileBody(
                  value: swipeRightAction.title(),
                  description: localizations.settings_swipe_action_right_description,
                  icon: swipeRightAction.icon,
                ),
                onPressed: (context) => _selectSwipeAction(context, SwipeDirection.right),
              ),
              SettingsTile.navigation(
                leading: const Icon(Icons.swipe_left),
                title: Text(localizations.settings_swipe_action_left),
                value: SettingNavigationTileBody(
                  value: swipeLeftAction.title(),
                  description: localizations.settings_swipe_action_left_description,
                  icon: swipeLeftAction.icon,
                ),
                onPressed: (context) => _selectSwipeAction(context, SwipeDirection.left),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
