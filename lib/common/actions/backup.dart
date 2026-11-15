import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../services/backup/auto_backup_service.dart';
import '../dialogs/require_backup_dialog.dart';
import '../extensions/build_context_extension.dart';
import '../files/files_utils.dart';
import '../preferences/preference_key.dart';
import '../ui/snack_bar_utils.dart';

/// Requires the user to select a backup directory.
///
/// If the [directoryLost] is enabled, also tells the user that the directory they selected is no longer accessible.
Future<void> requireBackupDirectory(BuildContext context, {bool directoryLost = false}) async {
  if (!kReleaseMode) {
    return;
  }

  final select = await showAdaptiveDialog<bool>(
    context: context,
    useRootNavigator: false,
    builder: (context) => RequireBackupDialog(directoryLost: directoryLost),
  );

  if (select == null || !select) {
    return;
  }

  await selectBackupDirectory();
}

/// Warns the user that the last automatic export was needed but could not be performed.
///
/// Waits for the automatic export to be done.
Future<void> warnIfAutoExportFailed(BuildContext context) async {
  await AutoExportUtils().initialized;

  if (AutoExportUtils().autoExportFailed && context.mounted) {
    SnackBarUtils().show(context, text: context.l.snack_bar_auto_export_failed);
  }
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
