import 'package:flutter/material.dart';

import '../../../constants/constants.dart';

/// Lists the options available in the selection menu for the available notes.
enum SelectionAvailableMenuOption {
  /// Copy the notes to the clipboard.
  copy(Icons.copy),

  /// Share the notes.
  share(Icons.share),

  /// Toggle whether the notes are pinned.
  togglePin(Icons.push_pin),

  /// Toggle whether the notes are locked.
  toggleLock(Icons.lock),

  /// Add labels to the notes.
  addLabels(Icons.new_label),

  /// Archive the notes.
  archive(Icons.archive),

  /// Delete the notes.
  delete(Icons.delete);

  /// Icon of the menu option.
  final IconData icon;

  /// An option displayed in the menu for the available notes.
  ///
  /// An action is represented by an [icon] and a [title].
  const SelectionAvailableMenuOption(this.icon);

  /// Returns the title of the menu option.
  String get title {
    switch (this) {
      case copy:
        return fl?.copyButtonLabel ?? 'Copy';
      case share:
        return fl?.shareButtonLabel ?? 'Share';
      case togglePin:
        return l.action_toggle_pin;
      case toggleLock:
        return l.action_toggle_lock;
      case addLabels:
        return l.menu_action_add_labels;
      case archive:
        return l.action_archive;
      case delete:
        return l.action_delete;
    }
  }

  /// Returns the [PopupMenuItem] widget of the menu option.
  PopupMenuItem<SelectionAvailableMenuOption> popupMenuItem(BuildContext context) {
    return PopupMenuItem(value: this, child: ListTile(leading: Icon(icon), title: Text(title)));
  }
}
