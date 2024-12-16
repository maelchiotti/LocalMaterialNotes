import 'package:flutter/cupertino.dart';
import 'package:localmaterialnotes/navigation/navigator_utils.dart';

// ignore_for_file: public_member_api_docs

/// Navigation routes of the application.
enum NavigationRoute {
  notes,
  notesEditor,
  manageLabels,
  label,
  bin,
  settings,
  settingsAppearance,
  settingsBehavior,
  settingsEditor,
  settingsLabels,
  settingsBackup,
  settingsAccessibility,
  settingsAbout,
  ;

  /// Goes to this route.
  void go(BuildContext context, Widget page) {
    NavigatorUtils.go(context, name, page);
  }

  /// Pushes this route.
  void push(BuildContext context, Widget page) {
    NavigatorUtils.push(context, name, page);
  }

  /// Pushes this route or goes to it depending on [shouldPush].
  void pushOrGo(BuildContext context, bool shouldPush, Widget page) {
    if (shouldPush) {
      push(context, page);
    } else {
      go(context, page);
    }
  }
}
