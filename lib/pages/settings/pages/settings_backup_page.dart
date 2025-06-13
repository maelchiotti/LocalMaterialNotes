import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:settings_tiles/settings_tiles.dart';
import 'package:simple_icons/simple_icons.dart';

import '../../../common/constants/constants.dart';
import '../../../common/constants/paddings.dart';
import '../../../common/extensions/build_context_extension.dart';
import '../../../common/extensions/string_extension.dart';
import '../../../common/files/files_utils.dart';
import '../../../common/navigation/app_bars/basic_app_bar.dart';
import '../../../common/navigation/top_navigation.dart';
import '../../../common/preferences/preference_key.dart';
import '../../../common/ui/snack_bar_utils.dart';
import '../../../models/note/note_status.dart';
import '../../../providers/labels/labels/labels_provider.dart';
import '../../../providers/labels/labels_list/labels_list_provider.dart';
import '../../../providers/labels/labels_navigation/labels_navigation_provider.dart';
import '../../../providers/notes/notes_provider.dart';
import '../../../providers/notifiers/notifiers.dart';
import '../../../providers/preferences/preferences_provider.dart';
import '../../../services/backup/auto_backup_service.dart';
import '../../../services/backup/backup_service.dart';
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
        await ref.read(notesProvider(status: NoteStatus.available, label: currentLabelFilter).notifier).get();
        await ref.read(notesProvider(status: NoteStatus.deleted).notifier).get();
        ref.read(preferencesProvider.notifier).reset();

        if (mounted) {
          SnackBarUtils().show(context, text: context.l.snack_bar_import_success);
        }

        setState(() {});
      }
    } catch (exception, stackTrace) {
      logger.e(exception.toString(), exception, stackTrace);

      if (mounted) {
        SnackBarUtils().show(context, text: exception.toString());
      }
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
        final exported = await ManualBackupService().manuallyExportAsJson(encrypt: encrypt, password: password);

        if (exported && mounted) {
          SnackBarUtils().show(context, text: context.l.snack_bar_export_success);
        }
      } catch (exception, stackTrace) {
        logger.e(exception.toString(), exception, stackTrace);

        if (mounted) {
          SnackBarUtils().show(context, text: exception.toString());
        }
      }
    });
  }

  /// Asks the user to configure the immediate export as Markdown.
  ///
  /// Asks where to store the export file.
  Future<void> _exportAsMarkdown() async {
    try {
      final exported = await ManualBackupService().exportAsMarkdown();

      if (exported && mounted) {
        SnackBarUtils().show(context, text: context.l.snack_bar_export_success);
      }
    } catch (exception, stackTrace) {
      logger.e(exception.toString(), exception, stackTrace);

      if (mounted) {
        SnackBarUtils().show(context, text: exception.toString());
      }
    }
  }

  /// Toggles the setting to enable the automatic export.
  Future<void> _toggleEnableAutoExport(bool toggled) async {
    await PreferenceKey.enableAutoExport.set(toggled);

    setState(() {});

    if (!toggled) {
      await PreferenceKey.lastAutoExportDate.remove();
      await PreferenceKey.autoExportEncryption.set(false);
      await PreferenceKey.autoExportPassword.remove();

      return;
    }

    // No need to await this, it can be performed in the background
    unawaited(AutoExportUtils().performAutoExportIfNeeded());
  }

  /// Toggles the setting to enable the automatic export encryption.
  ///
  /// If enabled, asks the user for the password used for the encryption.
  Future<void> _toggleAutoExportEncryption(bool toggled) async {
    if (!toggled) {
      await PreferenceKey.autoExportPassword.remove();
      await PreferenceKey.autoExportEncryption.set(false);

      setState(() {});

      return;
    }

    await showAdaptiveDialog<String>(
      context: context,
      useRootNavigator: false,
      builder: (context) => AutoExportPasswordDialog(
        title: context.l.settings_auto_export_encryption,
        description: context.l.dialog_export_encryption_description,
        secondaryDescription: context.l.dialog_export_encryption_secondary_description_auto,
      ),
    ).then((autoExportPassword) async {
      if (autoExportPassword == null) {
        return;
      }

      await PreferenceKey.autoExportPassword.set(autoExportPassword);
      await PreferenceKey.autoExportEncryption.set(true);

      setState(() {});
    });
  }

  /// Sets automatic export frequency to [frequency].
  Future<void> _submittedAutoExportFrequency(double frequency) async {
    setState(() {
      PreferenceKey.autoExportFrequency.set(frequency.toInt());
    });
  }

  /// Asks the user to choose a directory for the automatic export.
  Future<void> _setAutoExportDirectory() async {
    final autoExportDirectory = await selectDirectory();

    if (autoExportDirectory == null) {
      return;
    }

    await PreferenceKey.autoExportDirectory.set(autoExportDirectory);
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
    final enableAutoExport = PreferenceKey.enableAutoExport.preferenceOrDefault;
    final autoExportFrequency = PreferenceKey.autoExportFrequency.preferenceOrDefault;
    final autoExportEncryption = PreferenceKey.autoExportEncryption.preferenceOrDefault;
    final autoExportDirectory = AutoExportUtils().autoExportDirectory.decoded;

    return Scaffold(
      appBar: TopNavigation(appbar: BasicAppBar(title: context.l.navigation_settings_backup)),
      body: SingleChildScrollView(
        child: Padding(
          padding: Paddings.bottomSystemUi,
          child: Column(
            children: [
              SettingSection(
                divider: null,
                title: context.l.settings_backup_import,
                tiles: [
                  SettingActionTile(
                    icon: Icons.file_upload,
                    title: context.l.settings_import,
                    description: context.l.settings_import_description,
                    onTap: _import,
                  ),
                ],
              ),
              SettingSection(
                divider: null,
                title: context.l.settings_backup_manual_export,
                tiles: [
                  SettingActionTile(
                    icon: SimpleIcons.json,
                    title: context.l.settings_export_json,
                    description: context.l.settings_export_json_description,
                    onTap: _exportAsJson,
                  ),
                  SettingActionTile(
                    icon: SimpleIcons.markdown,
                    title: context.l.settings_export_markdown,
                    description: context.l.settings_export_markdown_description,
                    onTap: _exportAsMarkdown,
                  ),
                ],
              ),
              SettingSection(
                divider: null,
                title: context.l.settings_backup_auto_export,
                tiles: [
                  SettingSwitchTile(
                    icon: Icons.settings_backup_restore,
                    title: context.l.settings_auto_export,
                    description: context.l.settings_auto_export_description,
                    toggled: enableAutoExport,
                    onChanged: _toggleEnableAutoExport,
                  ),
                  SettingSwitchTile(
                    enabled: enableAutoExport,
                    icon: Icons.enhanced_encryption,
                    title: context.l.settings_auto_export_encryption,
                    description: context.l.settings_auto_export_encryption_description,
                    toggled: autoExportEncryption,
                    onChanged: _toggleAutoExportEncryption,
                  ),
                  SettingCustomSliderTile(
                    enabled: enableAutoExport,
                    icon: Symbols.calendar_clock,
                    title: context.l.settings_auto_export_frequency,
                    value: context.l.settings_auto_export_frequency_value(autoExportFrequency.toString()),
                    description: context.l.settings_auto_export_frequency_description,
                    dialogTitle: context.l.settings_auto_export_frequency,
                    label: (frequency) => context.l.settings_auto_export_frequency_value(frequency.toInt().toString()),
                    values: automaticExportFrequenciesValues,
                    initialValue: autoExportFrequency.toDouble(),
                    onSubmitted: _submittedAutoExportFrequency,
                  ),
                  SettingActionTile(
                    enabled: enableAutoExport,
                    icon: Icons.folder,
                    title: context.l.settings_auto_export_directory,
                    value: autoExportDirectory,
                    description: context.l.settings_auto_export_directory_description,
                    trailing: IconButton(
                      icon: const Icon(Symbols.reset_settings),
                      tooltip: context.l.tooltip_reset,
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
