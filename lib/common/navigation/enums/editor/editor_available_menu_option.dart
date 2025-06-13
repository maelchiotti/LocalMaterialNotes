import 'package:flutter/material.dart';

import '../../../extensions/build_context_extension.dart';

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
  String title(BuildContext context) {
    switch (this) {
      case copy:
        return context.fl.copyButtonLabel;
      case share:
        return context.fl.shareButtonLabel;
      case pin:
        return context.l.action_pin;
      case unpin:
        return context.l.action_unpin;
      case lock:
        return context.l.action_lock;
      case unlock:
        return context.l.action_unlock;
      case selectLabels:
        return context.l.menu_action_select_labels;
      case archive:
        return context.l.action_archive;
      case delete:
        return context.l.action_delete;
      case about:
        return context.l.action_about;
    }
  }

  /// Returns the [PopupMenuItem] widget of the menu option.
  PopupMenuItem<EditorAvailableMenuOption> popupMenuItem(BuildContext context) {
    return PopupMenuItem(
      value: this,
      child: ListTile(leading: Icon(icon), title: Text(title(context))),
    );
  }
}
