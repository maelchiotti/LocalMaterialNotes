import 'package:flutter/material.dart';

import '../../../constants/constants.dart';

/// Lists the options available in the editor's menu for the available notes.
enum EditorAvailableMenuOption {
  /// Copy the note to the clipboard.
  copy(Icons.copy),

  /// Share the note.
  share(Icons.share),

  /// Pin the note.
  pin(Icons.push_pin),

  /// Unpin the note.
  unpin(Icons.push_pin_outlined),

  /// Lock the note.
  lock(Icons.lock),

  /// Unlock the note.
  unlock(Icons.lock_open),

  /// Select the labels of the note.
  selectLabels(Icons.label),

  /// Archive the note.
  archive(Icons.archive),

  /// Delete the note.
  delete(Icons.delete),

  /// Show information about the note.
  about(Icons.info);

  /// Icon of the menu option.
  final IconData icon;

  /// An option displayed in the editor menu.
  const EditorAvailableMenuOption(this.icon);

  /// Returns the title of the menu option.
  String get title {
    switch (this) {
      case copy:
        return fl?.copyButtonLabel ?? 'Copy';
      case share:
        return fl?.shareButtonLabel ?? 'Share';
      case pin:
        return l.action_pin;
      case unpin:
        return l.action_unpin;
      case lock:
        return l.action_lock;
      case unlock:
        return l.action_unlock;
      case selectLabels:
        return l.menu_action_select_labels;
      case archive:
        return l.action_archive;
      case delete:
        return l.action_delete;
      case about:
        return l.action_about;
    }
  }

  /// Returns the [PopupMenuItem] widget of the menu option.
  PopupMenuItem<EditorAvailableMenuOption> popupMenuItem(BuildContext context) {
    return PopupMenuItem(value: this, child: ListTile(leading: Icon(icon), title: Text(title)));
  }
}
