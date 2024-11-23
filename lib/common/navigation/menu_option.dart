import 'package:flutter/material.dart';
import 'package:localmaterialnotes/common/constants/constants.dart';

// ignore_for_file: public_member_api_docs

/// Lists the options available in the menu of the editor's app bar.
enum MenuOption {
  togglePin(Icons.push_pin, alternativeIcon: Icons.push_pin_outlined),
  selectLabels(Icons.label),
  copy(Icons.copy),
  share(Icons.share),
  delete(Icons.delete, dangerous: true),
  restore(Icons.restore_from_trash),
  deletePermanently(Icons.delete_forever, dangerous: true),
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
  const MenuOption(this.icon, {this.alternativeIcon, this.dangerous = false});

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
  PopupMenuItem<MenuOption> popupMenuItem(BuildContext context, {bool alternative = false}) {
    return PopupMenuItem(
      value: this,
      child: ListTile(
        leading: Icon(
          alternative ? alternativeIcon : icon,
          color: dangerous ? Theme.of(context).colorScheme.error : null,
        ),
        title: Text(
          title(alternative),
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
