import 'package:flutter/material.dart';

import '../../../extensions/build_context_extension.dart';

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
  String title(BuildContext context) {
    switch (this) {
      case copy:
        return context.fl.copyButtonLabel;
      case share:
        return context.fl.shareButtonLabel;
      case togglePin:
        return context.l.action_toggle_pin;
      case toggleLock:
        return context.l.action_toggle_lock;
      case addLabels:
        return context.l.menu_action_add_labels;
      case archive:
        return context.l.action_archive;
      case delete:
        return context.l.action_delete;
    }
  }

  /// Returns the [PopupMenuItem] widget of the menu option.
  PopupMenuItem<SelectionAvailableMenuOption> popupMenuItem(BuildContext context) {
    return PopupMenuItem(value: this, child: ListTile(leading: Icon(icon), title: Text(title(context))));
  }
}
