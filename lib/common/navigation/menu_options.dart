import 'package:flutter/material.dart';
import 'package:localmaterialnotes/utils/constants/constants.dart';

/// Options available in the menu of the editor's app bar.
enum MenuOption {
  togglePin(Icons.push_pin, alternativeIcon: Icons.push_pin_outlined),
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

  const MenuOption(this.icon, {this.alternativeIcon});

  /// Returns the title of the menu option.
  ///
  /// Returns the alternative title if [alternative] is set to `true`.
  String title([bool alternative = false]) {
    switch (this) {
      case MenuOption.togglePin:
        return alternative ? localizations.menu_unpin : localizations.menu_pin;
      case MenuOption.share:
        return localizations.menu_share;
      case MenuOption.delete:
        return localizations.menu_delete;
      case MenuOption.restore:
        return localizations.menu_restore;
      case MenuOption.deletePermanently:
        return localizations.menu_delete_permanently;
      case MenuOption.about:
        return localizations.menu_about;
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
