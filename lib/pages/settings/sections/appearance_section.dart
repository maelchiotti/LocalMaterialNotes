import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';
import 'package:locale_names/locale_names.dart';
import 'package:localmaterialnotes/l10n/app_localizations/app_localizations.g.dart';
import 'package:localmaterialnotes/providers/notifiers.dart';
import 'package:localmaterialnotes/utils/constants/constants.dart';
import 'package:localmaterialnotes/utils/extensions/string_extension.dart';
import 'package:localmaterialnotes/utils/locale_utils.dart';
import 'package:localmaterialnotes/utils/preferences/preference_key.dart';
import 'package:localmaterialnotes/utils/preferences/preferences_utils.dart';
import 'package:localmaterialnotes/utils/theme_utils.dart';
import 'package:restart_app/restart_app.dart';

class AppearanceSection extends AbstractSettingsSection {
  const AppearanceSection(this.updateState, {super.key});

  final Function() updateState;

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
              onChanged: (locale) => Navigator.of(context).pop(locale),
            ),
            RadioListTile<ThemeMode>(
              value: ThemeMode.light,
              groupValue: ThemeUtils().themeMode,
              title: Text(localizations.settings_theme_light),
              selected: ThemeUtils().themeMode == ThemeMode.light,
              onChanged: (locale) => Navigator.of(context).pop(locale),
            ),
            RadioListTile<ThemeMode>(
              value: ThemeMode.dark,
              groupValue: ThemeUtils().themeMode,
              title: Text(localizations.settings_theme_dark),
              selected: ThemeUtils().themeMode == ThemeMode.dark,
              onChanged: (locale) => Navigator.of(context).pop(locale),
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

  void _toggleDynamicTheming(bool toggled) {
    PreferencesUtils().set<bool>(PreferenceKey.dynamicTheming.name, toggled);

    dynamicThemingNotifier.value = toggled;

    updateState();
  }

  void _toggleBlackTheming(bool toggled) {
    PreferencesUtils().set<bool>(PreferenceKey.blackTheming.name, toggled);

    blackThemingNotifier.value = toggled;

    updateState();
  }

  @override
  Widget build(BuildContext context) {
    final locale = LocaleUtils().appLocale.nativeDisplayLanguage.capitalized;

    return SettingsSection(
      title: Text(localizations.settings_appearance),
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
          value: Text(ThemeUtils().themeModeName),
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
          enabled: ThemeUtils().brightness == Brightness.dark,
          leading: const Icon(Icons.nightlight),
          title: Text(localizations.settings_black_theming),
          description: Text(localizations.settings_black_theming_description),
          initialValue: ThemeUtils().useBlackTheming,
          onToggle: _toggleBlackTheming,
        ),
      ],
    );
  }
}
