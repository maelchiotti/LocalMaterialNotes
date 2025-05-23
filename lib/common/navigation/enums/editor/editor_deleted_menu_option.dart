import 'package:flutter/material.dart';

import '../../../extensions/build_context_extension.dart';

/// Lists the options available in the editor's menu for the deleted notes.
enum EditorDeletedMenuOption {
  /// Restore the note.
  restore(Icons.restore_from_trash),

  /// Permanently delete the note.
  ///
  /// This action is [dangerous].
  deletePermanently(Icons.delete_forever, dangerous: true),

  /// Show information about the note.
  about(Icons.info);

  /// Icon of the menu option.
  final IconData icon;

  /// Whether the action is a dangerous one.
  ///
  /// Changes the text and icon colors to red.
  final bool dangerous;

  /// An option displayed in the menu for the deleted notes.
  ///
  /// If [dangerous] is `true`, the icon and the title are shown in red.
  const EditorDeletedMenuOption(this.icon, {this.dangerous = false});

  /// Returns the title of the menu option.
  String title(BuildContext context) {
    switch (this) {
      case restore:
        return context.l.action_restore;
      case deletePermanently:
        return context.l.action_delete_permanently;
      case about:
        return context.l.action_about;
    }
  }

  /// Returns the [PopupMenuItem] widget of the menu option.
  PopupMenuItem<EditorDeletedMenuOption> popupMenuItem(BuildContext context) {
    return PopupMenuItem(
      value: this,
      child: ListTile(
        leading: Icon(icon, color: dangerous ? Theme.of(context).colorScheme.error : null),
        title: Text(
          title(context),
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(color: dangerous ? Theme.of(context).colorScheme.error : null),
        ),
      ),
    );
  }
}
