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
import 'package:localmaterialnotes/providers/notifiers.dart';

/// Settings related to the behavior of the application.
class SettingsBehaviorPage extends StatefulWidget {
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
              onChanged: (confirmations) => Navigator.of(context).pop(confirmations),
            );
          }).toList(),
        );
      },
    ).then((confirmations) {
      if (confirmations == null) {
        return;
      }

      setState(() {
        PreferencesUtils().set<String>(PreferenceKey.confirmations.name, confirmations.name);
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
      builder: (context) {
        return SimpleDialog(
          clipBehavior: Clip.hardEdge,
          title: Text(localizations.settings_confirmations),
          children: SwipeAction.values.map((swipeAction) {
            return RadioListTile<SwipeAction>(
              value: swipeAction,
              groupValue: swipeActionPreference,
              title: Text(swipeAction.title),
              selected: swipeActionPreference == swipeAction,
              onChanged: (swipeAction) => Navigator.of(context).pop(swipeAction),
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
            PreferencesUtils().set<String>(PreferenceKey.swipeRightAction.name, swipeAction.name);
            swipeActionsNotifier.value = (swipeAction, swipeActionsNotifier.value.$2);
          case SwipeDirection.left:
            PreferencesUtils().set<String>(PreferenceKey.swipeLeftAction.name, swipeAction.name);
            swipeActionsNotifier.value = (swipeActionsNotifier.value.$1, swipeAction);
        }
      });
    });
  }

  /// Toggles Android's `FLAG_SECURE` to hide the app from the recent apps and prevent screenshots.
  Future<void> _setFlagSecure(bool toggled) async {
    setState(() {
      PreferencesUtils().set<bool>(PreferenceKey.flagSecure.name, toggled);
    });

    toggled ? await FlagSecure.set() : await FlagSecure.unset();
  }

  @override
  Widget build(BuildContext context) {
    final confirmations = Confirmations.fromPreference();
    final flagSecure = PreferenceKey.flagSecure.getPreferenceOrDefault<bool>();

    final swipeRightAction = swipeActionsNotifier.value.$1;
    final swipeLeftAction = swipeActionsNotifier.value.$2;

    return CustomSettingsList(
      sections: [
        SettingsSection(
          title: Text(localizations.settings_behavior_application),
          tiles: [
            SettingsTile.navigation(
              leading: const Icon(Icons.warning),
              title: Text(localizations.settings_confirmations),
              value: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    confirmations.title,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  Text(localizations.settings_confirmations_description),
                ],
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
              value: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    swipeRightAction.title,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  Text(localizations.settings_swipe_action_right_description),
                ],
              ),
              onPressed: (context) => _selectSwipeAction(context, SwipeDirection.right),
            ),
            SettingsTile.navigation(
              leading: const Icon(Icons.swipe_left),
              title: Text(localizations.settings_swipe_action_left),
              value: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    swipeLeftAction.title,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  Text(localizations.settings_swipe_action_left_description),
                ],
              ),
              onPressed: (context) => _selectSwipeAction(context, SwipeDirection.left),
            ),
          ],
        ),
      ],
    );
  }
}
