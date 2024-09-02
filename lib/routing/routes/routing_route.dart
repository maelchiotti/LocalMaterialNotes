import 'package:flutter/cupertino.dart';
import 'package:localmaterialnotes/common/constants/constants.dart';
import 'package:localmaterialnotes/common/extensions/build_context_extension.dart';

enum RoutingRoute {
  // Notes
  notes('/notes'),
  notesEditor('/notes/editor'),

  // Bin
  bin('/bin'),

  // Settings
  settings('/settings'),
  settingsAppearance('/settings/appearance'),
  settingsBehavior('/settings/behavior'),
  settingsEditor('/settings/editor'),
  settingsBackup('/settings/backup'),
  settingsAbout('/settings/about'),
  ;

  final String path;

  const RoutingRoute(this.path);

  /// Returns the title of the route.
  static String title(BuildContext context) {
    switch (context.route) {
      case notes:
        return localizations.navigation_notes;
      case bin:
        return localizations.navigation_bin;
      case settings:
        return localizations.navigation_settings;
      case settingsAppearance:
        return localizations.navigation_settings_appearance;
      case settingsBehavior:
        return localizations.navigation_settings_behavior;
      case settingsEditor:
        return localizations.navigation_settings_editor;
      case settingsBackup:
        return localizations.navigation_settings_backup;
      case settingsAbout:
        return localizations.navigation_settings_about;
      default:
        throw Exception('Unexpected route while getting its title: ${context.route.path}');
    }
  }
}
