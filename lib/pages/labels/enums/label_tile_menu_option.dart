import 'package:flutter/material.dart';

import '../../../common/constants/constants.dart';

/// Lists the options available in the menu of the labels tiles.
enum LabelTileMenuOption {
  /// Edit the label.
  edit(Icons.edit),

  /// Delete the label.
  delete(Icons.delete, dangerous: true),
  ;

  /// Icon of the menu option.
  final IconData icon;

  /// Whether the action is a dangerous one.
  ///
  /// Changes the text and icon colors to red.
  final bool dangerous;

  /// An option displayed in the labels tiles menu.
  ///
  /// An action is represented by an [icon] and a [title].
  const LabelTileMenuOption(this.icon, {this.dangerous = false});

  /// Returns the title of the menu option.
  String get title {
    switch (this) {
      case edit:
        return l.action_labels_edit;
      case delete:
        return l.action_labels_delete;
    }
  }

  /// Returns the [PopupMenuItem] widget of the menu option.
  PopupMenuItem<LabelTileMenuOption> popupMenuItem(BuildContext context) {
    return PopupMenuItem(
      value: this,
      child: ListTile(
        leading: Icon(
          icon,
          color: dangerous ? Theme.of(context).colorScheme.error : null,
        ),
        title: Text(
          title,
          style: dangerous
              ? Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  )
              : null,
        ),
      ),
    );
  }
}
