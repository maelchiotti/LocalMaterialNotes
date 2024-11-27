import 'package:flutter/material.dart';
import 'package:localmaterialnotes/common/constants/constants.dart';

// ignore_for_file: public_member_api_docs

/// Lists the options available in the menu of the labels tiles.
enum LabelMenuOption {
  edit(Icons.edit),
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
  const LabelMenuOption(this.icon, {this.dangerous = false});

  /// Returns the title of the menu option.
  String get title {
    switch (this) {
      case edit:
        return l.action_labels_edit;
      case delete:
        return l.action_labels_delete;
    }
  }

  /// Returns the `PopupMenuItem` widget of the menu option.
  PopupMenuItem<LabelMenuOption> popupMenuItem(BuildContext context) {
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
