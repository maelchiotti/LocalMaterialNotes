import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';
import 'package:localmaterialnotes/pages/settings/dialogs/auto_export_dialog.dart';
import 'package:localmaterialnotes/pages/settings/dialogs/manual_export_dialog.dart';
import 'package:localmaterialnotes/providers/bin/bin_provider.dart';
import 'package:localmaterialnotes/providers/notes/notes_provider.dart';
import 'package:localmaterialnotes/utils/auto_export_utils.dart';
import 'package:localmaterialnotes/utils/constants/constants.dart';
import 'package:localmaterialnotes/utils/database_utils.dart';
import 'package:localmaterialnotes/utils/extensions/uri_extension.dart';
import 'package:localmaterialnotes/utils/preferences/preference_key.dart';
import 'package:localmaterialnotes/utils/preferences/preferences_utils.dart';
import 'package:localmaterialnotes/utils/snack_bar_utils.dart';
import 'package:simple_icons/simple_icons.dart';

class BackupSection extends AbstractSettingsSection {
  const BackupSection(this.ref, this.updateState, {super.key});

  final WidgetRef ref;

  final Function() updateState;

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

      // If the auto export was disabled, just remove the encryption, last export date and password settings
      if (frequency == 0.0) {
        await PreferencesUtils().remove(PreferenceKey.autoExportEncryption);
        await PreferencesUtils().remove(PreferenceKey.lastAutoExportDate);
        await PreferencesUtils().deleteSecure(PreferenceKey.autoExportPassword);

        return;
      }

      final encrypt = autoExportSettings.$2;
      PreferencesUtils().set<bool>(PreferenceKey.autoExportEncryption.name, encrypt);

      // If the encryption was enabled, set the password. If not, make sure to delete it
      // (even though it might not have been set previously)
      if (encrypt) {
        final password = autoExportSettings.$3!;
        PreferencesUtils().setSecure(PreferenceKey.autoExportPassword, password);
      } else {
        await PreferencesUtils().deleteSecure(PreferenceKey.autoExportPassword);
      }

      // No need to await this, it can be performed in the background
      AutoExportUtils().performAutoExportIfNeeded();
    });

    updateState();
  }

  Future<void> exportAsJson(BuildContext context) async {
    await showAdaptiveDialog<(bool, String?)?>(
      context: context,
      builder: (context) => const ManualExportDialog(),
    ).then((shouldEncrypt) async {
      if (shouldEncrypt == null) {
        return;
      }

      final encrypt = shouldEncrypt.$1;

      try {
        final password = shouldEncrypt.$2;

        if (await DatabaseUtils().manuallyExportAsJson(encrypt, password)) {
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

  Future<void> import(BuildContext context) async {
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

  @override
  Widget build(BuildContext context) {
    final autoExportFrequency = PreferenceKey.autoExportFrequency.getPreferenceOrDefault<double>();
    final autoExportEncryption = PreferenceKey.autoExportEncryption.getPreferenceOrDefault<bool>();
    final autoExportDirectory = AutoExportUtils().backupsDirectory.toDecodedString;

    return SettingsSection(
      title: Text(localizations.settings_backup),
      tiles: [
        SettingsTile.navigation(
          leading: const Icon(Icons.settings_backup_restore),
          title: Text(localizations.settings_auto_export),
          value: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                autoExportFrequency == 0
                    ? localizations.settings_auto_export_disabled
                    : localizations.settings_auto_export_value(
                        autoExportEncryption.toString(),
                        autoExportFrequency.toInt().toString(),
                      ),
                style: Theme.of(context).textTheme.titleSmall,
              ),
              Text(localizations.settings_auto_export_description),
              Text(localizations.settings_auto_export_directory(autoExportDirectory)),
            ],
          ),
          onPressed: autoExportAsJson,
        ),
        SettingsTile.navigation(
          leading: const Icon(SimpleIcons.json),
          title: Text(localizations.settings_export_json),
          value: Text(localizations.settings_export_json_description),
          onPressed: exportAsJson,
        ),
        SettingsTile.navigation(
          leading: const Icon(SimpleIcons.markdown),
          title: Text(localizations.settings_export_markdown),
          value: Text(localizations.settings_export_markdown_description),
          onPressed: exportAsMarkdown,
        ),
        SettingsTile.navigation(
          leading: const Icon(Icons.file_upload),
          title: Text(localizations.settings_import),
          value: Text(localizations.settings_import_description),
          onPressed: import,
        ),
      ],
    );
  }
}
