import 'package:flutter/material.dart';

import '../../../extensions/build_context_extension.dart';

/// Lists the options available in the editor's menu for the archived notes.
enum EditorArchivedMenuOption {
  /// Copy the notes to the clipboard.
  copy(Icons.copy),

  /// Share the notes.
  share(Icons.share),

  /// Select the labels of the note.
  selectLabels(Icons.label),

  /// Unarchive the note.
  unarchive(Icons.unarchive),

  /// Show information about the note.
  about(Icons.info);

  /// Icon of the menu option.
  final IconData icon;

  /// An option displayed in the menu for the archived notes.
  const EditorArchivedMenuOption(this.icon);

  /// Returns the title of the menu option.
  String title(BuildContext context) {
    switch (this) {
      case copy:
        return context.fl.copyButtonLabel;
      case share:
        return context.fl.shareButtonLabel;
      case selectLabels:
        return context.l.menu_action_select_labels;
      case unarchive:
        return context.l.action_unarchive;
      case about:
        return context.l.action_about;
    }
  }

  /// Returns the [PopupMenuItem] widget of the menu option.
  ///
  /// Uses the alternative icon if [alternative] is set to `true`.
  PopupMenuItem<EditorArchivedMenuOption> popupMenuItem(BuildContext context) {
    return PopupMenuItem(
      value: this,
      child: ListTile(leading: Icon(icon), title: Text(title(context))),
    );
  }
}
