import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:settings_tiles/settings_tiles.dart';
import 'package:simple_icons/simple_icons.dart';

import '../../../common/constants/constants.dart';
import '../../../common/constants/paddings.dart';
import '../../../common/extensions/string_extension.dart';
import '../../../common/files/files_utils.dart';
import '../../../common/navigation/app_bars/basic_app_bar.dart';
import '../../../common/navigation/top_navigation.dart';
import '../../../common/preferences/preference_key.dart';
import '../../../common/ui/snack_bar_utils.dart';
import '../../../common/widgets/keys.dart';
import '../../../providers/bin/bin_provider.dart';
import '../../../providers/labels/labels/labels_provider.dart';
import '../../../providers/labels/labels_list/labels_list_provider.dart';
import '../../../providers/labels/labels_navigation/labels_navigation_provider.dart';
import '../../../providers/notes/notes_provider.dart';
import '../../../providers/notifiers/notifiers.dart';
import '../../../providers/preferences/preferences_provider.dart';
import '../../../services/backup/auto_backup_service.dart';
import '../../../services/backup/backup_service.dart';
import '../dialogs/auto_export_frequency_dialog.dart';
import '../dialogs/auto_export_password_dialog.dart';
import '../dialogs/manual_export_dialog.dart';

/// Settings related to the backup of the notes.
class SettingsBackupPage extends ConsumerStatefulWidget {
  /// Default constructor.
  const SettingsBackupPage({super.key});

  @override
  ConsumerState<SettingsBackupPage> createState() => _SettingsBackupPageState();
}

class _SettingsBackupPageState extends ConsumerState<SettingsBackupPage> {
  /// Asks the user to choose a JSON file to import.
  ///
  /// If the file is encrypted, asks for the password used to encrypt it.
  Future<void> _import() async {
    try {
      final imported = await ManualBackupService().import(context);

      if (imported) {
        await ref.read(labelsProvider.notifier).get();
        await ref.read(labelsListProvider.notifier).get();
        await ref.read(labelsNavigationProvider.notifier).get();
        await ref.read(notesProvider(label: currentLabelFilter).notifier).get();
        await ref.read(binProvider.notifier).get();
        ref.read(preferencesProvider.notifier).reset();

        SnackBarUtils.info(l.snack_bar_import_success).show();

        setState(() {});
      }
    } catch (exception, stackTrace) {
      logger.e(exception.toString(), exception, stackTrace);

      SnackBarUtils.info(exception.toString()).show();
    }
  }

  /// Asks the user to configure the immediate export as JSON.
  ///
  /// Asks whether to encrypt and where to store the export file.
  Future<void> _exportAsJson() async {
    await showAdaptiveDialog<(bool, String?)?>(
      context: context,
      useRootNavigator: false,
      builder: (context) => const ManualExportDialog(),
    ).then((shouldEncrypt) async {
      if (shouldEncrypt == null) {
        return;
      }

      final encrypt = shouldEncrypt.$1;

      try {
        final password = shouldEncrypt.$2;

        if (await ManualBackupService().manuallyExportAsJson(encrypt: encrypt, password: password)) {
          SnackBarUtils.info(l.snack_bar_export_success).show();
        }
      } catch (exception, stackTrace) {
        logger.e(exception.toString(), exception, stackTrace);

        SnackBarUtils.info(exception.toString()).show();
      }
    });
  }

  /// Asks the user to configure the immediate export as Markdown.
  ///
  /// Asks where to store the export file.
  Future<void> _exportAsMarkdown() async {
    try {
      if (await ManualBackupService().exportAsMarkdown()) {
        SnackBarUtils.info(l.snack_bar_export_success).show();
      }
    } catch (exception, stackTrace) {
      logger.e(exception.toString(), exception, stackTrace);

      SnackBarUtils.info(exception.toString()).show();
    }
  }

  /// Toggles the setting to enable the automatic export.
  Future<void> _toggleEnableAutoExport(bool toggled) async {
    await PreferenceKey.enableAutoExport.set(toggled);

    setState(() {});

    if (!toggled) {
      PreferenceKey.lastAutoExportDate.remove();
      PreferenceKey.autoExportEncryption.set(false);
      PreferenceKey.autoExportPassword.remove();

      return;
    }

    // No need to await
    AutoExportUtils().performAutoExportIfNeeded();
  }

  /// Toggles the setting to enable the automatic export encryption.
  ///
  /// If enabled, asks the user for the password used for the encryption.
  Future<void> _toggleAutoExportEncryption(bool toggled) async {
    if (!toggled) {
      PreferenceKey.autoExportPassword.remove();

      setState(() {
        PreferenceKey.autoExportEncryption.set(false);
      });

      return;
    }

    await showAdaptiveDialog<String>(
      context: context,
      useRootNavigator: false,
      builder: (context) => AutoExportPasswordDialog(
        title: l.settings_auto_export_encryption,
        description: l.dialog_export_encryption_description,
        secondaryDescription: l.dialog_export_encryption_secondary_description_auto,
      ),
    ).then((autoExportPassword) async {
      if (autoExportPassword == null) {
        return;
      }

      PreferenceKey.autoExportPassword.set(autoExportPassword);

      setState(() {
        PreferenceKey.autoExportEncryption.set(true);
      });
    });
  }

  /// Asks the user to configure the automatic export frequency.
  Future<void> _setAutoExportFrequency() async {
    await showAdaptiveDialog<int>(
      context: context,
      useRootNavigator: false,
      builder: (context) => const AutoExportFrequencyDialog(),
    ).then((autoExportFrequency) async {
      if (autoExportFrequency == null) {
        return;
      }

      setState(() {
        PreferenceKey.autoExportFrequency.set(autoExportFrequency);
      });
    });
  }

  /// Asks the user to choose a directory for the automatic export.
  Future<void> _setAutoExportDirectory() async {
    final autoExportDirectory = await selectDirectory();

    if (autoExportDirectory == null) {
      return;
    }

    PreferenceKey.autoExportDirectory.set(autoExportDirectory);

    await AutoExportUtils().setAutoExportDirectory();

    setState(() {});
  }

  /// Resets the directory of the automatic export to its default value.
  Future<void> _resetAutoExportDirectory() async {
    await PreferenceKey.autoExportDirectory.remove();

    await AutoExportUtils().setAutoExportDirectory();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final enableAutoExport = PreferenceKey.enableAutoExport.getPreferenceOrDefault();
    final autoExportFrequency = PreferenceKey.autoExportFrequency.getPreferenceOrDefault();
    final autoExportEncryption = PreferenceKey.autoExportEncryption.getPreferenceOrDefault();
    final autoExportDirectory = AutoExportUtils().autoExportDirectory.decoded;

    return Scaffold(
      appBar: TopNavigation(
        key: Keys.appBarSettingsMainSubpage,
        appbar: BasicAppBar(
          title: l.navigation_settings_backup,
          back: true,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: Paddings.bottomSystemUi,
          child: Column(
            children: [
              SettingSection(
                divider: null,
                title: l.settings_backup_import,
                tiles: [
                  SettingActionTile(
                    icon: Icons.file_upload,
                    title: l.settings_import,
                    description: l.settings_import_description,
                    onTap: _import,
                  ),
                ],
              ),
              SettingSection(
                divider: null,
                title: l.settings_backup_manual_export,
                tiles: [
                  SettingActionTile(
                    icon: SimpleIcons.json,
                    title: l.settings_export_json,
                    description: l.settings_export_json_description,
                    onTap: _exportAsJson,
                  ),
                  SettingActionTile(
                    icon: SimpleIcons.markdown,
                    title: l.settings_export_markdown,
                    description: l.settings_export_markdown_description,
                    onTap: _exportAsMarkdown,
                  ),
                ],
              ),
              SettingSection(
                divider: null,
                title: l.settings_backup_auto_export,
                tiles: [
                  SettingSwitchTile(
                    icon: Icons.settings_backup_restore,
                    title: l.settings_auto_export,
                    description: l.settings_auto_export_description,
                    toggled: enableAutoExport,
                    onChanged: _toggleEnableAutoExport,
                  ),
                  SettingSwitchTile(
                    enabled: enableAutoExport,
                    icon: Icons.enhanced_encryption,
                    title: l.settings_auto_export_encryption,
                    description: l.settings_auto_export_encryption_description,
                    toggled: autoExportEncryption,
                    onChanged: _toggleAutoExportEncryption,
                  ),
                  SettingActionTile(
                    enabled: enableAutoExport,
                    icon: Symbols.calendar_clock,
                    title: l.settings_auto_export_frequency,
                    value: l.settings_auto_export_frequency_value(autoExportFrequency.toString()),
                    description: l.settings_auto_export_frequency_description,
                    onTap: _setAutoExportFrequency,
                  ),
                  SettingActionTile(
                    enabled: enableAutoExport,
                    icon: Icons.folder,
                    title: l.settings_auto_export_directory,
                    value: autoExportDirectory,
                    description: l.settings_auto_export_directory_description,
                    trailing: IconButton(
                      icon: const Icon(Symbols.reset_settings),
                      tooltip: l.tooltip_reset,
                      onPressed: enableAutoExport ? _resetAutoExportDirectory : null,
                    ),
                    onTap: _setAutoExportDirectory,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
