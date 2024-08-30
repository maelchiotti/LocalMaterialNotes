import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';
import 'package:localmaterialnotes/common/constants/constants.dart';
import 'package:localmaterialnotes/common/extensions/uri_extension.dart';
import 'package:localmaterialnotes/common/preferences/preference_key.dart';
import 'package:localmaterialnotes/common/preferences/preferences_utils.dart';
import 'package:localmaterialnotes/pages/settings/dialogs/auto_export_frequency_dialog.dart';
import 'package:localmaterialnotes/pages/settings/dialogs/auto_export_password_dialog.dart';
import 'package:localmaterialnotes/pages/settings/dialogs/manual_export_dialog.dart';
import 'package:localmaterialnotes/pages/settings/widgets/custom_settings_list.dart';
import 'package:localmaterialnotes/providers/bin/bin_provider.dart';
import 'package:localmaterialnotes/providers/notes/notes_provider.dart';
import 'package:localmaterialnotes/utils/auto_export_utils.dart';
import 'package:localmaterialnotes/utils/database_utils.dart';
import 'package:localmaterialnotes/utils/files_utils.dart';
import 'package:localmaterialnotes/utils/snack_bar_utils.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:simple_icons/simple_icons.dart';

/// Settings related to the backup of the notes.
class SettingsBackupPage extends ConsumerStatefulWidget {
  const SettingsBackupPage({super.key});

  @override
  ConsumerState<SettingsBackupPage> createState() => _SettingsBackupPageState();
}

class _SettingsBackupPageState extends ConsumerState<SettingsBackupPage> {
  /// Asks the user to choose a JSON file to import.
  ///
  /// If the file is encrypted, asks for the password used to encrypt it.
  Future<void> _import(BuildContext context) async {
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

  /// Asks the user to configure the immediate export as JSON.
  ///
  /// Asks whether to encrypt and where to store the export file.
  Future<void> _exportAsJson(BuildContext context) async {
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

  /// Asks the user to configure the immediate export as Markdown.
  ///
  /// Asks where to store the export file.
  Future<void> _exportAsMarkdown(BuildContext context) async {
    try {
      if (await DatabaseUtils().exportAsMarkdown()) {
        SnackBarUtils.info(localizations.settings_export_success).show();
      }
    } catch (exception, stackTrace) {
      log(exception.toString(), stackTrace: stackTrace);

      SnackBarUtils.info(exception.toString()).show();
    }
  }

  /// Toggles the setting to enable the automatic export.
  Future<void> _toggleEnableAutoExport(bool toggled) async {
    if (!toggled) {
      PreferencesUtils().remove(PreferenceKey.lastAutoExportDate);
      _toggleAutoExportEncryption(false);
    } else {
      // No need to await
      AutoExportUtils().performAutoExportIfNeeded();
    }

    setState(() {
      PreferencesUtils().set<bool>(PreferenceKey.enableAutoExport, toggled);
    });
  }

  /// Toggles the setting to enable the automatic export encryption.
  ///
  /// If enabled, asks the user for the password used for the encryption.
  Future<void> _toggleAutoExportEncryption(bool toggled) async {
    if (!toggled) {
      PreferencesUtils().remove(PreferenceKey.autoExportPassword);

      setState(() {
        PreferencesUtils().set<bool>(PreferenceKey.autoExportEncryption, false);
      });

      return;
    }

    await showAdaptiveDialog<String>(
      context: context,
      builder: (context) => AutoExportPasswordDialog(
        title: localizations.settings_auto_export_encryption,
        description: localizations.dialog_export_encryption_description,
        secondaryDescription: localizations.dialog_export_encryption_secondary_description_auto,
      ),
    ).then((autoExportPassword) async {
      if (autoExportPassword == null) {
        return;
      }

      PreferencesUtils().set(PreferenceKey.autoExportPassword, autoExportPassword);

      setState(() {
        PreferencesUtils().set<bool>(PreferenceKey.autoExportEncryption, true);
      });
    });
  }

  /// Asks the user to configure the automatic export frequency.
  Future<void> _setAutoExportFrequency(BuildContext context) async {
    await showAdaptiveDialog<int>(
      context: context,
      builder: (context) => const AutoExportFrequencyDialog(),
    ).then((autoExportFrequency) async {
      if (autoExportFrequency == null) {
        return;
      }

      setState(() {
        PreferencesUtils().set<int>(PreferenceKey.autoExportFrequency, autoExportFrequency);
      });
    });
  }

  /// Asks the user to choose a directory for the automatic export.
  Future<void> _setAutoExportDirectory(_) async {
    final autoExportDirectory = await pickDirectory();

    if (autoExportDirectory == null) {
      return;
    }

    PreferencesUtils().set<String>(PreferenceKey.autoExportDirectory, autoExportDirectory.path);
    await AutoExportUtils().setAutoExportDirectory();

    setState(() {});
  }

  /// Resets the directory of the automatic export to its default value.
  Future<void> _resetAutoExportDirectory() async {
    PreferencesUtils().remove(PreferenceKey.autoExportDirectory);
    await AutoExportUtils().setAutoExportDirectory();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final enableAutoExport = PreferenceKey.enableAutoExport.getPreferenceOrDefault<bool>();
    final autoExportFrequency = PreferenceKey.autoExportFrequency.getPreferenceOrDefault<int>();
    final autoExportEncryption = PreferenceKey.autoExportEncryption.getPreferenceOrDefault<bool>();
    final autoExportDirectory = AutoExportUtils().autoExportDirectory.display;

    return CustomSettingsList(
      sections: [
        SettingsSection(
          title: Text(localizations.settings_backup_import),
          tiles: [
            SettingsTile.navigation(
              leading: const Icon(Icons.file_upload),
              title: Text(localizations.settings_import),
              value: Text(localizations.settings_import_description),
              onPressed: _import,
            ),
          ],
        ),
        SettingsSection(
          title: Text(localizations.settings_backup_manual_export),
          tiles: [
            SettingsTile.navigation(
              leading: const Icon(SimpleIcons.json),
              title: Text(localizations.settings_export_json),
              value: Text(localizations.settings_export_json_description),
              onPressed: _exportAsJson,
            ),
            SettingsTile.navigation(
              leading: const Icon(SimpleIcons.markdown),
              title: Text(localizations.settings_export_markdown),
              value: Text(localizations.settings_export_markdown_description),
              onPressed: _exportAsMarkdown,
            ),
          ],
        ),
        SettingsSection(
          title: Text(localizations.settings_backup_auto_export),
          tiles: [
            SettingsTile.switchTile(
              leading: const Icon(Icons.settings_backup_restore),
              title: Text(localizations.settings_auto_export),
              description: Text(localizations.settings_auto_export_description),
              initialValue: enableAutoExport,
              onToggle: _toggleEnableAutoExport,
            ),
            SettingsTile.switchTile(
              enabled: enableAutoExport,
              leading: const Icon(Icons.enhanced_encryption),
              title: Text(localizations.settings_auto_export_encryption),
              description: Text(localizations.settings_auto_export_encryption_description),
              initialValue: autoExportEncryption,
              onToggle: _toggleAutoExportEncryption,
            ),
            SettingsTile.navigation(
              enabled: enableAutoExport,
              leading: const Icon(Symbols.calendar_clock),
              title: Text(localizations.settings_auto_export_frequency),
              value: Text(
                localizations.settings_auto_export_frequency_description(autoExportFrequency.toInt().toString()),
              ),
              onPressed: _setAutoExportFrequency,
            ),
            SettingsTile.navigation(
              enabled: enableAutoExport,
              leading: const Icon(Icons.folder),
              title: Text(localizations.settings_auto_export_directory),
              value: Text(localizations.settings_auto_export_directory_description(autoExportDirectory)),
              trailing: IconButton(
                icon: const Icon(Symbols.reset_settings),
                tooltip: localizations.tooltip_reset,
                onPressed: _resetAutoExportDirectory,
              ),
              onPressed: _setAutoExportDirectory,
            ),
          ],
        ),
      ],
    );
  }
}
