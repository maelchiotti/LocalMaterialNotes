import 'package:flag_secure/flag_secure.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';
import 'package:localmaterialnotes/utils/constants/constants.dart';
import 'package:localmaterialnotes/utils/preferences/confirmations.dart';
import 'package:localmaterialnotes/utils/preferences/preference_key.dart';
import 'package:localmaterialnotes/utils/preferences/preferences_utils.dart';

class BehaviorSection extends AbstractSettingsSection {
  const BehaviorSection(this.updateState, {super.key});

  final Function() updateState;

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
              onChanged: (locale) => Navigator.of(context).pop(locale),
            );
          }).toList(),
        );
      },
    ).then((confirmationsValue) {
      if (confirmationsValue == null) {
        return;
      }

      PreferencesUtils().set<String>(PreferenceKey.confirmations.name, confirmationsValue.name);

      updateState();
    });
  }

  Future<void> _setFlagSecure(bool toggled) async {
    PreferencesUtils().set<bool>(PreferenceKey.flagSecure.name, toggled);

    toggled ? await FlagSecure.set() : await FlagSecure.unset();

    updateState();
  }

  void _toggleShowSeparators(bool toggled) {
    PreferencesUtils().set<bool>(PreferenceKey.showSeparators.name, toggled);

    updateState();
  }

  void _toggleShowTilesBackground(bool toggled) {
    PreferencesUtils().set<bool>(PreferenceKey.showTilesBackground.name, toggled);

    updateState();
  }

  @override
  Widget build(BuildContext context) {
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
                Confirmations.fromPreference().title,
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
