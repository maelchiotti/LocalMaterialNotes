import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:locale_names/locale_names.dart';
import 'package:localmaterialnotes/l10n/app_localizations.g.dart';
import 'package:localmaterialnotes/utils/asset.dart';
import 'package:localmaterialnotes/utils/constants/constants.dart';
import 'package:localmaterialnotes/utils/constants/paddings.dart';
import 'package:localmaterialnotes/utils/constants/sizes.dart';
import 'package:localmaterialnotes/utils/database_manager.dart';
import 'package:localmaterialnotes/utils/extensions/string_extension.dart';
import 'package:localmaterialnotes/utils/info_manager.dart';
import 'package:localmaterialnotes/utils/locale_manager.dart';
import 'package:localmaterialnotes/utils/preferences/confirmations.dart';
import 'package:localmaterialnotes/utils/preferences/preference_key.dart';
import 'package:localmaterialnotes/utils/preferences/preferences_manager.dart';
import 'package:localmaterialnotes/utils/snack_bar_manager.dart';
import 'package:localmaterialnotes/utils/theme_manager.dart';
import 'package:restart_app/restart_app.dart';
import 'package:url_launcher/url_launcher.dart';

class Interactions {
  Future<void> selectLanguage(BuildContext context) async {
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
      if (locale == null) return;

      LocaleManager().setLocale(locale);
      await Restart.restartApp();
    });
  }

  Future<void> selectTheme(BuildContext context) async {
    await showAdaptiveDialog<ThemeMode>(
      context: context,
      builder: (context) {
        return SimpleDialog(
          clipBehavior: Clip.hardEdge,
          title: Text(localizations.settings_theme),
          children: [
            RadioListTile<ThemeMode>(
              value: ThemeMode.system,
              groupValue: ThemeManager().themeMode,
              title: Text(localizations.settings_theme_system),
              selected: ThemeManager().themeMode == ThemeMode.system,
              onChanged: (locale) => Navigator.of(context).pop(locale),
            ),
            RadioListTile<ThemeMode>(
              value: ThemeMode.light,
              groupValue: ThemeManager().themeMode,
              title: Text(localizations.settings_theme_light),
              selected: ThemeManager().themeMode == ThemeMode.light,
              onChanged: (locale) => Navigator.of(context).pop(locale),
            ),
            RadioListTile<ThemeMode>(
              value: ThemeMode.dark,
              groupValue: ThemeManager().themeMode,
              title: Text(localizations.settings_theme_dark),
              selected: ThemeManager().themeMode == ThemeMode.dark,
              onChanged: (locale) => Navigator.of(context).pop(locale),
            ),
          ],
        );
      },
    ).then((themeMode) {
      if (themeMode == null) return;

      ThemeManager().setThemeMode(themeMode);
    });
  }

  void toggleDynamicTheming(bool value) {
    PreferencesManager().set<bool>(PreferenceKey.dynamicTheming.name, value);
    dynamicThemingNotifier.value = value;
  }

  void toggleBlackTheming(bool value) {
    PreferencesManager().set<bool>(PreferenceKey.blackTheming.name, value);
    blackThemingNotifier.value = value;
  }

  void toggleSeparator(bool value) {
    PreferencesManager().set<bool>(PreferenceKey.separator.name, value);
  }

  Future<void> selectConfirmations(BuildContext context) async {
    await showAdaptiveDialog<Confirmations>(
      context: context,
      builder: (context) {
        return SimpleDialog(
          clipBehavior: Clip.hardEdge,
          title: Text(localizations.settings_confirmations),
          children: Confirmations.values.map((confirmationsValue) {
            return RadioListTile<Confirmations>(
              value: confirmationsValue,
              groupValue: Confirmations.fromPreferences(),
              title: Text(confirmationsValue.title),
              selected: Confirmations.fromPreferences() == confirmationsValue,
              onChanged: (locale) => Navigator.of(context).pop(locale),
            );
          }).toList(),
        );
      },
    ).then((confirmationsValue) {
      if (confirmationsValue == null) return;

      PreferencesManager().set<String>(PreferenceKey.confirmations.name, confirmationsValue.name);
    });
  }

  Future<void> backupAsJson(BuildContext context) async {
    try {
      await DatabaseManager().exportAsJson();
    } catch (exception, stackTrace) {
      log(exception.toString(), stackTrace: stackTrace);
      SnackBarManager.info(localizations.settings_export_fail(exception.toString())).show();
      return;
    }

    SnackBarManager.info(localizations.settings_export_success).show();
  }

  Future<void> backupAsMarkdown(BuildContext context) async {
    try {
      await DatabaseManager().exportAsMarkdown();
    } catch (exception, stackTrace) {
      log(exception.toString(), stackTrace: stackTrace);
      SnackBarManager.info(localizations.settings_export_fail(exception.toString())).show();
      return;
    }

    SnackBarManager.info(localizations.settings_export_success).show();
  }

  Future<void> restore(BuildContext context) async {
    try {
      await DatabaseManager().import();
    } catch (exception, stackTrace) {
      log(exception.toString(), stackTrace: stackTrace);
      SnackBarManager.info(localizations.settings_import_fail(exception.toString())).show();
      return;
    }

    SnackBarManager.info(localizations.settings_import_success).show();
  }

  Future<void> showAbout(BuildContext context) async {
    showAboutDialog(
      context: context,
      applicationName: localizations.app_name,
      applicationVersion: InfoManager().appVersion,
      applicationIcon: Image.asset(
        Asset.icons.path,
        filterQuality: FilterQuality.medium,
        fit: BoxFit.fitWidth,
        width: Sizes.size64.size,
      ),
      applicationLegalese: localizations.settings_licence_description,
      children: [
        Padding(padding: Paddings.padding16.vertical),
        Text(
          localizations.app_tagline,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        Padding(padding: Paddings.padding8.vertical),
        Text(localizations.app_about(localizations.app_name)),
      ],
    );
  }

  void openGitHub(_) {
    launchUrl(
      Uri(
        scheme: 'https',
        host: 'github.com',
        path: 'maelchiotti/LocalMaterialNotes',
      ),
    );
  }

  void openLicense(_) {
    launchUrl(
      Uri(
        scheme: 'https',
        host: 'github.com',
        path: 'maelchiotti/LocalMaterialNotes/blob/main/LICENSE',
      ),
    );
  }

  void openIssues(_) {
    launchUrl(
      Uri(
        scheme: 'https',
        host: 'github.com',
        path: 'maelchiotti/LocalMaterialNotes/issues',
      ),
    );
  }
}
