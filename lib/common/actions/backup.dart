import 'package:flutter/material.dart';

import '../../services/backup/auto_backup_service.dart';
import '../dialogs/require_backup_dialog.dart';
import '../files/files_utils.dart';
import '../preferences/preference_key.dart';

/// Requires the user to select a backup directory.
Future<void> requireBackupDirectory(BuildContext context) async {
  final select = await showAdaptiveDialog<bool>(
    context: context,
    useRootNavigator: false,
    builder: (context) => RequireBackupDialog(),
  );

  if (select == null || !select) {
    return;
  }

  await selectBackupDirectory();
}

/// Asks the user to select a backup directory.
Future<void> selectBackupDirectory() async {
  final autoExportDirectory = await selectDirectory();

  if (autoExportDirectory == null) {
    return;
  }

  await PreferenceKey.autoExportDirectory.set(autoExportDirectory);
  await AutoExportUtils().setAutoExportDirectory();
}
