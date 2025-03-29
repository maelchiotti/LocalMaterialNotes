import 'package:flutter/material.dart';

import '../../../extensions/build_context_extension.dart';

/// Lists the options available in the selection menu for the archived notes.
enum SelectionArchivedMenuOption {
  /// Copy the notes to the clipboard.
  copy(Icons.copy),

  /// Share the notes.
  share(Icons.share),

  /// Unarchive the note.
  unarchive(Icons.unarchive);

  /// Icon of the menu option.
  final IconData icon;

  /// An option displayed in the menu for the archived notes.
  ///
  /// An action is represented by an [icon] and a [title].
  const SelectionArchivedMenuOption(this.icon);

  /// Returns the title of the menu option.
  String title(BuildContext context) {
    switch (this) {
      case copy:
        return context.fl.copyButtonLabel;
      case share:
        return context.fl.shareButtonLabel;
      case unarchive:
        return context.l.action_unarchive;
    }
  }

  /// Returns the [PopupMenuItem] widget of the menu option.
  ///
  /// Uses the alternative icon if [alternative] is set to `true`.
  PopupMenuItem<SelectionArchivedMenuOption> popupMenuItem(BuildContext context) {
    return PopupMenuItem(value: this, child: ListTile(leading: Icon(icon), title: Text(title(context))));
  }
}
