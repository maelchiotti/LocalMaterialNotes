import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';
import 'package:locale_names/locale_names.dart';
import 'package:localmaterialnotes/common/constants/constants.dart';
import 'package:localmaterialnotes/common/extensions/string_extension.dart';
import 'package:localmaterialnotes/common/preferences/preference_key.dart';
import 'package:localmaterialnotes/common/preferences/preferences_utils.dart';
import 'package:localmaterialnotes/l10n/app_localizations/app_localizations.g.dart';
import 'package:localmaterialnotes/l10n/localization_completion.dart';
import 'package:localmaterialnotes/pages/settings/widgets/custom_settings_list.dart';
import 'package:localmaterialnotes/providers/notifiers.dart';
import 'package:localmaterialnotes/utils/locale_utils.dart';
import 'package:localmaterialnotes/utils/theme_utils.dart';
import 'package:restart_app/restart_app.dart';

/// Settings related to the appearance of the application.
class SettingsAppearancePage extends StatefulWidget {
  const SettingsAppearancePage({super.key});

  @override
  State<SettingsAppearancePage> createState() => _SettingsAppearancePageState();
}

class _SettingsAppearancePageState extends State<SettingsAppearancePage> {
  /// Asks the user to select the language of the application.
  ///
  /// Restarts the application if the language is changed.
  Future<void> _selectLanguage(BuildContext context) async {
    await showAdaptiveDialog<Locale>(
      context: context,
      builder: (context) {
        return SimpleDialog(
          clipBehavior: Clip.hardEdge,
          title: Text(localizations.settings_language),
          children: AppLocalizations.supportedLocales.map((locale) {
            return RadioListTile<Locale>(
              value: locale,
              groupValue: Localizations.localeOf(context),
              title: Text(locale.nativeDisplayLanguage.capitalized),
              subtitle: Text(LocalizationCompletion.getFormattedPercentage(locale)),
              selected: Localizations.localeOf(context) == locale,
              onChanged: (locale) => Navigator.of(context).pop(locale),
            );
          }).toList(),
        );
      },
    ).then((locale) async {
      if (locale == null) {
        return;
      }

      LocaleUtils().setLocale(locale);

      // The Restart package crashes the app if used in debug mode
      if (!kDebugMode) {
        await Restart.restartApp();
      }
    });
  }

  /// Asks the user to select the theme of the application.
  Future<void> _selectTheme(BuildContext context) async {
    await showAdaptiveDialog<ThemeMode>(
      context: context,
      builder: (context) {
        return SimpleDialog(
          clipBehavior: Clip.hardEdge,
          title: Text(localizations.settings_theme),
          children: [
            RadioListTile<ThemeMode>(
              value: ThemeMode.system,
              groupValue: ThemeUtils().themeMode,
              title: Text(localizations.settings_theme_system),
              selected: ThemeUtils().themeMode == ThemeMode.system,
              onChanged: (themeMode) => Navigator.of(context).pop(themeMode),
            ),
            RadioListTile<ThemeMode>(
              value: ThemeMode.light,
              groupValue: ThemeUtils().themeMode,
              title: Text(localizations.settings_theme_light),
              selected: ThemeUtils().themeMode == ThemeMode.light,
              onChanged: (themeMode) => Navigator.of(context).pop(themeMode),
            ),
            RadioListTile<ThemeMode>(
              value: ThemeMode.dark,
              groupValue: ThemeUtils().themeMode,
              title: Text(localizations.settings_theme_dark),
              selected: ThemeUtils().themeMode == ThemeMode.dark,
              onChanged: (themeMode) => Navigator.of(context).pop(themeMode),
            ),
          ],
        );
      },
    ).then((themeMode) {
      if (themeMode == null) {
        return;
      }

      ThemeUtils().setThemeMode(themeMode);
    });
  }

  /// Toggles the dynamic theming.
  void _toggleDynamicTheming(bool toggled) {
    setState(() {
      PreferencesUtils().set<bool>(PreferenceKey.dynamicTheming, toggled);
    });

    dynamicThemingNotifier.value = toggled;
  }

  /// Toggles the black theming.
  void _toggleBlackTheming(bool toggled) {
    setState(() {
      PreferencesUtils().set<bool>(PreferenceKey.blackTheming, toggled);
    });

    blackThemingNotifier.value = toggled;
  }

  /// Toggles the setting to show background of the notes tiles.
  void _toggleShowTitlesOnly(bool toggled) {
    setState(() {
      PreferencesUtils().set<bool>(PreferenceKey.showTitlesOnly, toggled);
    });

    showTitlesOnlyNotifier.value = toggled;
  }

  /// Toggles the setting to show background of the notes tiles.
  void _toggleShowTilesBackground(bool toggled) {
    setState(() {
      PreferencesUtils().set<bool>(PreferenceKey.showTilesBackground, toggled);
    });

    showTilesBackgroundNotifier.value = toggled;
  }

  /// Toggles the setting to show the separators between the notes tiles.
  void _toggleShowSeparators(bool toggled) {
    setState(() {
      PreferencesUtils().set<bool>(PreferenceKey.showSeparators, toggled);
    });

    showSeparatorsNotifier.value = toggled;
  }

  @override
  Widget build(BuildContext context) {
    final locale = LocaleUtils().appLocale.nativeDisplayLanguage.capitalized;
    final showUseBlackTheming = Theme.of(context).colorScheme.brightness == Brightness.dark;

    final showTitlesOnly = PreferenceKey.showTitlesOnly.getPreferenceOrDefault<bool>();
    final showTilesBackground = PreferenceKey.showTilesBackground.getPreferenceOrDefault<bool>();
    final showSeparators = PreferenceKey.showSeparators.getPreferenceOrDefault<bool>();

    return CustomSettingsList(
      sections: [
        SettingsSection(
          title: Text(localizations.settings_appearance_application),
          tiles: [
            SettingsTile.navigation(
              leading: const Icon(Icons.language),
              title: Text(localizations.settings_language),
              value: Text(locale),
              onPressed: _selectLanguage,
            ),
            SettingsTile.navigation(
              leading: const Icon(Icons.palette),
              title: Text(localizations.settings_theme),
              value: Text(ThemeUtils().themeModeTitle),
              onPressed: _selectTheme,
            ),
            SettingsTile.switchTile(
              enabled: ThemeUtils().isDynamicThemingAvailable,
              leading: const Icon(Icons.bolt),
              title: Text(localizations.settings_dynamic_theming),
              description: Text(localizations.settings_dynamic_theming_description),
              initialValue: ThemeUtils().useDynamicTheming,
              onToggle: _toggleDynamicTheming,
            ),
            SettingsTile.switchTile(
              enabled: showUseBlackTheming,
              leading: const Icon(Icons.nightlight),
              title: Text(localizations.settings_black_theming),
              description: Text(localizations.settings_black_theming_description),
              initialValue: ThemeUtils().useBlackTheming,
              onToggle: _toggleBlackTheming,
            ),
          ],
        ),
        SettingsSection(
          title: Text(localizations.settings_appearance_notes_tiles),
          tiles: [
            SettingsTile.switchTile(
              leading: const Icon(Icons.view_compact),
              title: Text(localizations.settings_show_titles_only),
              description: Text(localizations.settings_show_titles_only_description),
              initialValue: showTitlesOnly,
              onToggle: _toggleShowTitlesOnly,
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
        ),
      ],
    );
  }
}
