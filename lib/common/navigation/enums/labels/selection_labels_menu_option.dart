import 'package:flutter/material.dart';

import '../../../constants/constants.dart';

/// Lists the options available for the selection menu on the labels.
enum SelectionLabelsMenuOption {
  /// Toggle whether the label is pinned.
  togglePin(Icons.push_pin),

  /// Toggle whether the label is visible.
  toggleVisible(Icons.label),

  /// Toggle whether the label is locked.
  toggleLock(Icons.label),

  /// Delete the note.
  ///
  /// This action is [dangerous].
  delete(Icons.delete, dangerous: true),
  ;

  /// Icon of the menu option.
  final IconData icon;

  /// Whether the action is a dangerous one.
  ///
  /// Changes the text and icon colors to red.
  final bool dangerous;

  /// An option displayed in the menu for the labels.
  ///
  /// An action is represented by an [icon] and a [title].
  ///
  /// If [dangerous] is `true`, the icon and the title are shown in red.
  const SelectionLabelsMenuOption(this.icon, {this.dangerous = false});

  /// Returns the title of the menu option.
  String get title {
    switch (this) {
      case togglePin:
        return l.action_labels_toggle_pins;
      case toggleVisible:
        return l.action_labels_toggle_visibile;
      case toggleLock:
        return l.action_labels_toggle_lock;
      case delete:
        return l.action_delete;
    }
  }

  /// Returns the [PopupMenuItem] widget of the menu option.
  PopupMenuItem<SelectionLabelsMenuOption> popupMenuItem(BuildContext context) {
    return PopupMenuItem(
      value: this,
      child: ListTile(
        leading: Icon(
          icon,
          color: dangerous ? Theme.of(context).colorScheme.error : null,
        ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: dangerous ? Theme.of(context).colorScheme.error : null,
              ),
        ),
      ),
    );
  }
}
