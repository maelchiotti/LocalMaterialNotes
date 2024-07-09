import 'dart:developer';

import 'package:flag_secure/flag_secure.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:locale_names/locale_names.dart';
import 'package:localmaterialnotes/common/dialogs/auto_export_dialog.dart';
import 'package:localmaterialnotes/common/dialogs/manual_export_dialog.dart';
import 'package:localmaterialnotes/l10n/app_localizations/app_localizations.g.dart';
import 'package:localmaterialnotes/providers/bin/bin_provider.dart';
import 'package:localmaterialnotes/providers/notes/notes_provider.dart';
import 'package:localmaterialnotes/utils/asset.dart';
import 'package:localmaterialnotes/utils/auto_export_utils.dart';
import 'package:localmaterialnotes/utils/constants/constants.dart';
import 'package:localmaterialnotes/utils/constants/paddings.dart';
import 'package:localmaterialnotes/utils/constants/sizes.dart';
import 'package:localmaterialnotes/utils/database_utils.dart';
import 'package:localmaterialnotes/utils/extensions/string_extension.dart';
import 'package:localmaterialnotes/utils/info_utils.dart';
import 'package:localmaterialnotes/utils/locale_utils.dart';
import 'package:localmaterialnotes/utils/preferences/confirmations.dart';
import 'package:localmaterialnotes/utils/preferences/preference_key.dart';
import 'package:localmaterialnotes/utils/preferences/preferences_utils.dart';
import 'package:localmaterialnotes/utils/snack_bar_utils.dart';
import 'package:localmaterialnotes/utils/theme_utils.dart';
import 'package:restart_app/restart_app.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsActions {
  void toggleBooleanSetting(PreferenceKey preferenceKey, bool toggled) {
    PreferencesUtils().set<bool>(preferenceKey.name, toggled);
  }

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

  void toggleDynamicTheming(bool toggled) {
    PreferencesUtils().set<bool>(PreferenceKey.dynamicTheming.name, toggled);
    dynamicThemingNotifier.value = toggled;
  }

  void toggleBlackTheming(bool toggled) {
    PreferencesUtils().set<bool>(PreferenceKey.blackTheming.name, toggled);
    blackThemingNotifier.value = toggled;
  }

  Future<void> selectConfirmations(BuildContext context) async {
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
    });
  }

  Future<void> setFlagSecure(bool toggled) async {
    toggleBooleanSetting(PreferenceKey.flagSecure, toggled);

    toggled ? await FlagSecure.set() : await FlagSecure.unset();
  }

  Future<void> autoExportAsJson(BuildContext context) async {
    await showAdaptiveDialog<(double, bool, String?)>(
      context: context,
      builder: (context) => const AutoExportDialog(),
    ).then((autoExportSettings) async {
      if (autoExportSettings == null) {
        return;
      }

      final frequency = autoExportSettings.$1;
      PreferencesUtils().set<double>(PreferenceKey.autoExportFrequency.name, frequency);

      // If the auto export was disabled, just remove the encryption and passphrase settings
      if (frequency == 0.0) {
        await PreferencesUtils().remove(PreferenceKey.autoExportEncryption);
        await PreferencesUtils().deleteSecure(PreferenceKey.autoExportPassphrase);

        return;
      }

      final encrypt = autoExportSettings.$2;
      PreferencesUtils().set<bool>(PreferenceKey.autoExportEncryption.name, encrypt);

      // If the encryption was enabled, set the passphrase. If not, make sure to delete it
      // (even though it might not have been set previously)
      if (encrypt) {
        final passphrase = autoExportSettings.$3!;
        PreferencesUtils().setSecure(PreferenceKey.autoExportPassphrase, passphrase);
      } else {
        await PreferencesUtils().deleteSecure(PreferenceKey.autoExportPassphrase);
      }

      // No need to await this, it can be performed in the background
      AutoExportUtils().performAutoExportIfNeeded();
    });
  }

  Future<void> exportAsJson(BuildContext context) async {
    await showAdaptiveDialog<(bool, String)>(
      context: context,
      builder: (context) => const ManualExportDialog(),
    ).then((shouldEncrypt) async {
      if (shouldEncrypt == null) {
        return;
      }

      final encrypt = shouldEncrypt.$1;
      final passphrase = shouldEncrypt.$2;

      try {
        if (await DatabaseUtils().exportAsJson(encrypt, passphrase)) {
          SnackBarUtils.info(localizations.settings_export_success).show();
        }
      } catch (exception, stackTrace) {
        log(exception.toString(), stackTrace: stackTrace);

        SnackBarUtils.info(exception.toString()).show();
      }
    });
  }

  Future<void> exportAsMarkdown(BuildContext context) async {
    try {
      if (await DatabaseUtils().exportAsMarkdown()) {
        SnackBarUtils.info(localizations.settings_export_success).show();
      }
    } catch (exception, stackTrace) {
      log(exception.toString(), stackTrace: stackTrace);

      SnackBarUtils.info(exception.toString()).show();
    }
  }

  Future<void> import(BuildContext context, WidgetRef ref) async {
    try {
      final imported = await DatabaseUtils().import(context);

      if (imported) {
        await ref.read(notesProvider.notifier).get();
        await ref.read(binProvider.notifier).get();

        SnackBarUtils.info(localizations.settings_import_success).show();
      }
    } catch (exception, stackTrace) {
      log(exception.toString(), stackTrace: stackTrace);

      SnackBarUtils.info(exception.toString()).show();
    }
  }

  Future<void> showAbout(BuildContext context) async {
    showAboutDialog(
      context: context,
      useRootNavigator: false,
      applicationName: localizations.app_name,
      applicationVersion: InfoUtils().appVersion,
      applicationIcon: Image.asset(
        Asset.icon.path,
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
