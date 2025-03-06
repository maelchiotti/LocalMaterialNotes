import 'package:flutter/material.dart';

import '../../../constants/constants.dart';

/// Lists the options available in the selection menu for the deleted notes.
enum SelectionDeletedMenuOption {
  /// Restore the note.
  restore(Icons.restore_from_trash),

  /// Permanently delete the note.
  ///
  /// This action is [dangerous].
  deletePermanently(Icons.delete_forever, dangerous: true);

  /// Icon of the menu option.
  final IconData icon;

  /// Whether the action is a dangerous one.
  ///
  /// Changes the text and icon colors to red.
  final bool dangerous;

  /// An option displayed in the menu for the deleted notes.
  ///
  /// An action is represented by an [icon] and a [title].
  ///
  /// If [dangerous] is `true`, the icon and the title are shown in red.
  const SelectionDeletedMenuOption(this.icon, {this.dangerous = false});

  /// Returns the title of the menu option.
  String get title {
    switch (this) {
      case restore:
        return l.action_restore;
      case deletePermanently:
        return l.action_delete_permanently;
    }
  }

  /// Returns the [PopupMenuItem] widget of the menu option.
  PopupMenuItem<SelectionDeletedMenuOption> popupMenuItem(BuildContext context) {
    return PopupMenuItem(
      value: this,
      child: ListTile(
        leading: Icon(icon, color: dangerous ? Theme.of(context).colorScheme.error : null),
        title: Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(color: dangerous ? Theme.of(context).colorScheme.error : null),
        ),
      ),
    );
  }
}
