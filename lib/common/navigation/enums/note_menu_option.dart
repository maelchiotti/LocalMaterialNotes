import 'package:flutter/material.dart';

import '../../constants/constants.dart';

/// Lists the options available in the menu of the editor app bar for the notes that are not deleted.
enum NoteMenuOption {
  /// Toggle whether the note is pinned.
  togglePin(Icons.push_pin, alternativeIcon: Icons.push_pin_outlined),

  /// Select the labels of the note.
  selectLabels(Icons.label),

  /// Copy the note to the clipboard.
  copy(Icons.copy),

  /// Share the note.
  share(Icons.share),

  /// Delete the note.
  ///
  /// This action is [dangerous].
  delete(Icons.delete, dangerous: true),

  /// Show information about the note.
  about(Icons.info),
  ;

  /// Icon of the menu option.
  final IconData icon;

  /// Alternative icon of the menu option if the option has two states.
  final IconData? alternativeIcon;

  /// Whether the action is a dangerous one.
  ///
  /// Changes the text and icon colors to red.
  final bool dangerous;

  /// An option displayed in the editor's menu.
  ///
  /// An action is represented by an [icon] and a [title]. If it has two states, it can have an [alternativeIcon].
  const NoteMenuOption(this.icon, {this.alternativeIcon, this.dangerous = false});

  /// Returns the title of the menu option.
  ///
  /// Returns the alternative title if [alternative] is set to `true`.
  String title([bool alternative = false]) {
    switch (this) {
      case togglePin:
        return alternative ? l.action_unpin : l.action_pin;
      case selectLabels:
        return l.menu_action_labels;
      case copy:
        return flutterL?.copyButtonLabel ?? 'Copy';
      case share:
        return flutterL?.shareButtonLabel ?? 'Share';
      case delete:
        return l.action_delete;
      case about:
        return l.action_about;
    }
  }

  /// Returns the `PopupMenuItem` widget of the menu option.
  ///
  /// Uses the alternative icon if [alternative] is set to `true`.
  PopupMenuItem<NoteMenuOption> popupMenuItem(BuildContext context, {bool alternative = false}) => PopupMenuItem(
        value: this,
        child: ListTile(
          leading: Icon(
            alternative ? alternativeIcon : icon,
            color: dangerous ? Theme.of(context).colorScheme.error : null,
          ),
          title: Text(
            title(alternative),
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: dangerous ? Theme.of(context).colorScheme.error : null,
                ),
          ),
        ),
      );
}
