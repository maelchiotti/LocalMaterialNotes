import 'package:flag_secure/flag_secure.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';
import 'package:localmaterialnotes/utils/constants/constants.dart';
import 'package:localmaterialnotes/utils/preferences/enums/confirmations.dart';
import 'package:localmaterialnotes/utils/preferences/enums/swipe_action.dart';
import 'package:localmaterialnotes/utils/preferences/enums/swipe_direction.dart';
import 'package:localmaterialnotes/utils/preferences/preference_key.dart';
import 'package:localmaterialnotes/utils/preferences/preferences_utils.dart';

/// Settings related to the behavior of the application.
class BehaviorSection extends AbstractSettingsSection {
  const BehaviorSection(this.updateState, {super.key});

  /// Triggers an update of the screen.
  final Function() updateState;

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

      PreferencesUtils().set<String>(PreferenceKey.confirmations.name, confirmations.name);

      updateState();
    });
  }

  /// Asks the user to choose which action should be triggered when swiping the notes tiles in the [swipeDirection].
  Future<void> _selectSwipeAction(BuildContext context, SwipeDirection swipeDirection) async {
    SwipeAction swipeActionPreference;
    switch (swipeDirection) {
      case SwipeDirection.right:
        swipeActionPreference = SwipeAction.rightFromPreference();
      case SwipeDirection.left:
        swipeActionPreference = SwipeAction.leftFromPreference();
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

      switch (swipeDirection) {
        case SwipeDirection.right:
          PreferencesUtils().set<String>(PreferenceKey.swipeRightAction.name, swipeAction.name);
        case SwipeDirection.left:
          PreferencesUtils().set<String>(PreferenceKey.swipeLeftAction.name, swipeAction.name);
      }

      updateState();
    });
  }

  /// Toggles Android's `FLAG_SECURE` to hide the app from the recent apps and prevent screenshots.
  Future<void> _setFlagSecure(bool toggled) async {
    PreferencesUtils().set<bool>(PreferenceKey.flagSecure.name, toggled);

    toggled ? await FlagSecure.set() : await FlagSecure.unset();

    updateState();
  }

  /// Toggles the setting to show the separators between the notes tiles.
  void _toggleShowSeparators(bool toggled) {
    PreferencesUtils().set<bool>(PreferenceKey.showSeparators.name, toggled);

    updateState();
  }

  /// Toggles the setting to show background of the notes tiles.
  void _toggleShowTilesBackground(bool toggled) {
    PreferencesUtils().set<bool>(PreferenceKey.showTilesBackground.name, toggled);

    updateState();
  }

  @override
  Widget build(BuildContext context) {
    final confirmations = Confirmations.fromPreference();
    final swipeRightAction = SwipeAction.rightFromPreference();
    final swipeLeftAction = SwipeAction.leftFromPreference();
    final flagSecure = PreferenceKey.flagSecure.getPreferenceOrDefault<bool>();
    final showSeparators = PreferenceKey.showSeparators.getPreferenceOrDefault<bool>();
    final showTilesBackground = PreferenceKey.showTilesBackground.getPreferenceOrDefault<bool>();

    return SettingsSection(
      title: Text(localizations.settings_behavior),
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
        SettingsTile.switchTile(
          leading: const Icon(Icons.security),
          title: Text(localizations.settings_flag_secure),
          description: Text(localizations.settings_flag_secure_description),
          initialValue: flagSecure,
          onToggle: _setFlagSecure,
        ),
        SettingsTile.switchTile(
          leading: const Icon(Icons.safety_divider),
          title: Text(localizations.settings_show_separators),
          description: Text(localizations.settings_show_separators_description),
          initialValue: showSeparators,
          onToggle: _toggleShowSeparators,
        ),
        SettingsTile.switchTile(
          leading: const Icon(Icons.gradient),
          title: Text(localizations.settings_show_tiles_background),
          description: Text(localizations.settings_show_tiles_background_description),
          initialValue: showTilesBackground,
          onToggle: _toggleShowTilesBackground,
        ),
      ],
    );
  }
}
