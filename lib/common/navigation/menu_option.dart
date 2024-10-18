import 'package:flutter/material.dart';
import 'package:localmaterialnotes/common/constants/constants.dart';

// ignore_for_file: public_member_api_docs

/// Lists the options available in the menu of the editor's app bar.
enum MenuOption {
  togglePin(Icons.push_pin, alternativeIcon: Icons.push_pin_outlined),
  copy(Icons.copy),
  share(Icons.share),
  delete(Icons.delete),
  restore(Icons.restore_from_trash),
  deletePermanently(Icons.delete_forever),
  about(Icons.info),
  ;

  /// Icon of the menu option.
  final IconData icon;

  /// Alternative icon of the menu option if the option has two states.
  final IconData? alternativeIcon;

  /// An option displayed in the editor's menu.
  ///
  /// A swipe action is represented by an [icon] and a [title]. If it has two states, it can have an [alternativeIcon].
  const MenuOption(this.icon, {this.alternativeIcon});

  /// Returns the title of the menu option.
  ///
  /// Returns the alternative title if [alternative] is set to `true`.
  String title([bool alternative = false]) {
    switch (this) {
      case togglePin:
        return alternative ? l.action_unpin : l.action_pin;
      case copy:
        return flutterL?.copyButtonLabel ?? 'Copy';
      case share:
        return flutterL?.shareButtonLabel ?? 'Share';
      case delete:
        return l.action_delete;
      case restore:
        return l.action_restore;
      case deletePermanently:
        return l.action_delete_permanently;
      case about:
        return l.action_about;
    }
  }

  /// Returns the `PopupMenuItem` widget of the menu option.
  ///
  /// Uses the alternative icon if [alternative] is set to `true`.
  PopupMenuItem<MenuOption> popupMenuItem([bool alternative = false]) {
    return PopupMenuItem(
      value: this,
      child: ListTile(
        leading: Icon(alternative ? alternativeIcon : icon),
        title: Text(title(alternative)),
      ),
    );
  }
}
