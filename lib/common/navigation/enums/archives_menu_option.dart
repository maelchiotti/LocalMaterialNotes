import 'package:flutter/material.dart';

import '../../constants/constants.dart';

/// Lists the options available in the menus for the archived notes.
enum ArchivesMenuOption {
  /// Unarchive the note.
  unarchive(Icons.unarchive),

  /// Show information about the note.
  about(Icons.info),
  ;

  /// Icon of the menu option.
  final IconData icon;

  /// An option displayed in the menu for the archived notes.
  ///
  /// An action is represented by an [icon] and a [title].
  const ArchivesMenuOption(this.icon);

  /// Returns the title of the menu option.
  String get title {
    switch (this) {
      case unarchive:
        return l.action_unarchive;
      case about:
        return l.action_about;
    }
  }

  /// Returns the [PopupMenuItem] widget of the menu option.
  ///
  /// Uses the alternative icon if [alternative] is set to `true`.
  PopupMenuItem<ArchivesMenuOption> popupMenuItem(BuildContext context) {
    return PopupMenuItem(
      value: this,
      child: ListTile(
        leading: Icon(
          icon,
        ),
        title: Text(
          title,
        ),
      ),
    );
  }
}
