import 'package:flutter/material.dart';

import '../../../common/extensions/build_context_extension.dart';

/// Lists the options available in the menu of the labels tiles.
enum LabelTileMenuOption {
  /// Make the label visible.
  show(Icons.visibility),

  /// Hide the label.
  hide(Icons.visibility_off),

  /// Pin the label.
  pin(Icons.push_pin),

  /// Unpin the label.
  unpin(Icons.push_pin_outlined),

  /// Lock the label.
  lock(Icons.lock),

  /// Unlock the label.
  unlock(Icons.lock_open),

  /// Edit the label.
  edit(Icons.edit),

  /// Delete the label.
  delete(Icons.delete, dangerous: true);

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
  String title(BuildContext context) {
    switch (this) {
      case show:
        return context.l.action_labels_show;
      case hide:
        return context.l.action_labels_hide;
      case pin:
        return context.l.action_labels_pin;
      case unpin:
        return context.l.action_labels_unpin;
      case lock:
        return context.l.action_labels_lock;
      case unlock:
        return context.l.action_labels_unlock;
      case edit:
        return context.l.action_labels_edit;
      case delete:
        return context.l.action_labels_delete;
    }
  }

  /// Returns the [PopupMenuItem] widget of the menu option.
  PopupMenuItem<LabelTileMenuOption> popupMenuItem(BuildContext context) {
    return PopupMenuItem(
      value: this,
      child: ListTile(
        leading: Icon(icon, color: dangerous ? Theme.of(context).colorScheme.error : null),
        title: Text(
          title(context),
          style: dangerous
              ? Theme.of(context).textTheme.titleSmall?.copyWith(color: Theme.of(context).colorScheme.error)
              : null,
        ),
      ),
    );
  }
}
