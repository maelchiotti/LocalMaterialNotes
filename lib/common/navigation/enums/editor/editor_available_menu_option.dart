import 'package:flutter/material.dart';

import '../../../constants/constants.dart';

/// Lists the options available in the editor's menu for the available notes.
enum EditorAvailableMenuOption {
  /// Copy the note to the clipboard.
  copy(Icons.copy),

  /// Share the note.
  share(Icons.share),

  /// Toggle whether the note is pinned.
  togglePin(Icons.push_pin, alternativeIcon: Icons.push_pin_outlined),

  /// Select the labels of the note.
  selectLabels(Icons.label),

  /// Archive the note.
  archive(Icons.archive),

  /// Delete the note.
  delete(Icons.delete),

  /// Show information about the note.
  about(Icons.info),
  ;

  /// Icon of the menu option.
  final IconData icon;

  /// Alternative icon of the menu option if the option has two states.
  final IconData? alternativeIcon;

  /// An option displayed in the editor menu.
  ///
  /// An action is represented by an [icon] and a [title].
  /// If it has two states, it can have an [alternativeIcon].
  const EditorAvailableMenuOption(this.icon, {this.alternativeIcon});

  /// Returns the title of the menu option.
  ///
  /// Returns the alternative title if [alternative] is set to `true`.
  String title(bool alternative) {
    switch (this) {
      case copy:
        return flutterL?.copyButtonLabel ?? 'Copy';
      case share:
        return flutterL?.shareButtonLabel ?? 'Share';
      case togglePin:
        return alternative ? l.action_unpin : l.action_pin;
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
  ///
  /// Uses the alternative icon and title if [alternative] is set to `true`.
  PopupMenuItem<EditorAvailableMenuOption> popupMenuItem(BuildContext context, {bool alternative = false}) {
    return PopupMenuItem(
      value: this,
      child: ListTile(
        leading: Icon(alternative ? alternativeIcon : icon),
        title: Text(title(alternative)),
      ),
    );
  }
}
