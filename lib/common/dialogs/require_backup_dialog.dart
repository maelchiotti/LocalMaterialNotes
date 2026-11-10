import 'package:flutter/material.dart';

import '../extensions/build_context_extension.dart';

/// Require backup dialog.
class RequireBackupDialog extends StatelessWidget {
  /// Dialog to require the user to select a backup location.
  ///
  /// If [directoryLost] is enabled, it starts by telling the user that the directory they selected is no longer
  /// accessible.
  const RequireBackupDialog({super.key, this.directoryLost = false});

  /// Whether the backup directory selected by the user is no longer accessible.
  final bool directoryLost;

  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      title: Text(context.l.dialog_require_backup_title),
      content: SingleChildScrollView(
        child: Column(
          spacing: 16.0,
          children: [
            if (directoryLost) Text(context.l.dialog_require_backup_lost),
            Text(context.l.dialog_require_backup_description),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          style: TextButton.styleFrom(foregroundColor: Theme.of(context).colorScheme.error),
          child: Text(context.l.dialog_require_backup_ignore),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text(context.l.dialog_require_backup_select),
        ),
      ],
    );
  }
}
