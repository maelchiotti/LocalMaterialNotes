import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:locale_names/locale_names.dart';
import 'package:localmaterialnotes/l10n/app_localizations.g.dart';
import 'package:localmaterialnotes/pages/settings/shortcut.dart';
import 'package:localmaterialnotes/utils/asset.dart';
import 'package:localmaterialnotes/utils/constants/constants.dart';
import 'package:localmaterialnotes/utils/constants/sizes.dart';
import 'package:localmaterialnotes/utils/extensions/string_extension.dart';
import 'package:localmaterialnotes/utils/locale_manager.dart';
import 'package:localmaterialnotes/utils/package_info_manager.dart';
import 'package:localmaterialnotes/utils/preferences/confirmations.dart';
import 'package:localmaterialnotes/utils/preferences/preference_key.dart';
import 'package:localmaterialnotes/utils/preferences/preferences_manager.dart';
import 'package:localmaterialnotes/utils/theme_manager.dart';
import 'package:url_launcher/url_launcher_string.dart';

class Interactions {
  Future<void> selectTheme(BuildContext context) async {
    await showAdaptiveDialog<ThemeMode>(
      context: context,
      builder: (context) {
        return SimpleDialog(
          clipBehavior: Clip.hardEdge,
          title: Text(localizations.settings_theme),
          children: [
            ListTile(
              leading: const Icon(Icons.smartphone),
              selected: ThemeManager().themeMode == ThemeMode.system,
              title: Text(localizations.settings_theme_system),
              onTap: () => context.pop(ThemeMode.system),
            ),
            ListTile(
              leading: const Icon(Icons.light_mode),
              selected: ThemeManager().themeMode == ThemeMode.light,
              title: Text(localizations.settings_theme_light),
              onTap: () => context.pop(ThemeMode.light),
            ),
            ListTile(
              leading: const Icon(Icons.dark_mode),
              selected: ThemeManager().themeMode == ThemeMode.dark,
              title: Text(localizations.settings_theme_dark),
              onTap: () => context.pop(ThemeMode.dark),
            ),
          ],
        );
      },
    ).then((themeMode) {
      if (themeMode == null) return;

      ThemeManager().setThemeMode(themeMode);
    });
  }

  void toggleDynamicTheming(bool? value) {
    if (value == null) return;

    PreferencesManager().set<bool>(PreferenceKey.dynamicTheming.name, value);
    dynamicThemingNotifier.value = value;
  }

  void toggleBlackTheming(bool? value) {
    if (value == null) return;

    PreferencesManager().set<bool>(PreferenceKey.blackTheming.name, value);
    blackThemingNotifier.value = value;
  }

  Future<void> selectLanguage(BuildContext context) async {
    await showAdaptiveDialog<Locale>(
      context: context,
      builder: (context) {
        return SimpleDialog(
          clipBehavior: Clip.hardEdge,
          title: Text(localizations.settings_language),
          children: AppLocalizations.supportedLocales.map((locale) {
            return ListTile(
              selected: locale == Localizations.localeOf(context),
              title: Text(locale.nativeDisplayLanguage.capitalized),
              onTap: () => context.pop(locale),
            );
          }).toList(),
        );
      },
    ).then((locale) {
      if (locale == null) return;

      LocaleManager().setLocale(locale);
    });
  }

  Future<void> selectConfirmations(BuildContext context) async {
    await showAdaptiveDialog<Confirmations>(
      context: context,
      builder: (context) {
        return SimpleDialog(
          clipBehavior: Clip.hardEdge,
          title: Text(localizations.settings_confirmations),
          children: Confirmations.values.map((confirmationsValue) {
            return ListTile(
              title: Text(confirmationsValue.title),
              selected: Confirmations.fromPreferences() == confirmationsValue,
              onTap: () => context.pop(confirmationsValue),
            );
          }).toList(),
        );
      },
    ).then((confirmationsValue) {
      if (confirmationsValue == null) return;

      PreferencesManager().set<String>(PreferenceKey.confirmations.name, confirmationsValue.name);
    });
  }

  Future<void> showShortcuts(BuildContext context) async {
    await showAdaptiveDialog(
      context: context,
      builder: (context) {
        return AlertDialog.adaptive(
          clipBehavior: Clip.hardEdge,
          title: Text(localizations.settings_shortcuts),
          content: SingleChildScrollView(
            child: ListBody(
              children: Shortcut.values.map((shortcut) {
                return ListTile(
                  title: Text(shortcut.title),
                  trailing: Text(shortcut.keys),
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(localizations.button_close),
            ),
          ],
        );
      },
    );
  }

  Future<void> showAbout(BuildContext context) async {
    showAboutDialog(
      context: context,
      applicationName: localizations.app_name,
      applicationVersion: PackageInfoManager().version,
      applicationIcon: Image.asset(
        Asset.icon.path,
        width: Sizes.size64.size,
        height: Sizes.size64.size,
      ),
      applicationLegalese: localizations.settings_licence_description,
    );
  }

  void openGitHub(_) {
    launchUrlString('https://github.com/maelchiotti/LocalMaterialNotes');
  }

  void openLicense(_) {
    launchUrlString('https://github.com/maelchiotti/LocalMaterialNotes/blob/main/LICENSE');
  }

  void openIssues(_) {
    launchUrlString('https://github.com/maelchiotti/LocalMaterialNotes/issues');
  }
}
