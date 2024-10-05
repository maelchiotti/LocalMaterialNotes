import 'package:flutter/cupertino.dart';
import 'package:localmaterialnotes/common/constants/constants.dart';
import 'package:localmaterialnotes/common/extensions/build_context_extension.dart';

// ignore_for_file: public_member_api_docs

/// Lists the routes of the application.
enum RoutingRoute {
  // Notes

  /// Notes.
  notes('/notes'),

  /// Notes > Editor.
  notesEditor('/notes/editor'),

  // Bin

  /// Bin.
  bin('/bin'),

  // Settings

  /// Settings.
  settings('/settings'),

  /// Settings > Appearance.
  settingsAppearance('/settings/appearance'),

  /// Settings > Behavior.
  settingsBehavior('/settings/behavior'),

  /// Settings > Editor.
  settingsEditor('/settings/editor'),

  /// Settings > Backup.
  settingsBackup('/settings/backup'),

  /// Settings > About.
  settingsAbout('/settings/about'),
  ;

  /// Path of the route.
  final String path;

  /// A route represented by its [path] and has a [title].
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
