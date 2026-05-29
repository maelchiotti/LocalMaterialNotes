import 'package:flutter/material.dart';

import '../extensions/build_context_extension.dart';

/// Require backup dialog.
class RequireBackupDialog extends StatelessWidget {
  /// Dialog to require the user to select a backup location.
  const RequireBackupDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      title: Text(context.l.dialog_require_backup_title),
      content: SingleChildScrollView(child: Column(children: [Text(context.l.dialog_require_backup_description)])),
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
