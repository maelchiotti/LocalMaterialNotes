import 'package:collection/collection.dart';
import 'package:go_router/go_router.dart';
import 'package:localmaterialnotes/utils/constants/constants.dart';
import 'package:localmaterialnotes/utils/extensions/go_router_extension.dart';

/// Routes for the router of the application.
enum RouterRoute {
  // Notes
  notes('/notes', drawerIndex: 0),
  editor('editor', fullPath: '/notes/editor'),

  // Bin
  bin('/bin', drawerIndex: 1),

  // Settings
  settings('/settings', drawerIndex: 2),
  settingsAppearance('appearance', fullPath: '/settings/appearance'),
  settingsBehavior('behavior', fullPath: '/settings/behavior'),
  settingsEditor('editor', fullPath: '/settings/editor'),
  settingsBackup('backup', fullPath: '/settings/backup'),
  settingsAbout('about', fullPath: '/settings/about'),
  ;

  /// Path of the route (last element of the path only).
  final String path;

  /// Full path of the route (including the parent routes).
  final String? fullPath;

  /// Index of the route in the drawer, if any.
  final int? drawerIndex;

  const RouterRoute(this.path, {this.fullPath, this.drawerIndex});

  /// Returns the title of the route.
  String get title {
    switch (this) {
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
        throw Exception('Unexpected route while getting its title: $this');
    }
  }

  /// Returns the current drawer index of the application depending on the current route.
  static int get currentDrawerIndex {
    final drawerIndex = currentRoute.drawerIndex;

    if (drawerIndex == null) {
      throw Exception('No current drawer index');
    }

    return drawerIndex;
  }

  /// Returns the route corresponding to the drawer [index].
  static RouterRoute getRouteFromIndex(int index) {
    final route = values.firstWhereOrNull((route) => route.drawerIndex == index);

    if (route == null) {
      throw Exception('No route for index: $index');
    }

    return route;
  }

  /// Returns the current route of the application.
  static RouterRoute get currentRoute {
    final location = GoRouter.of(navigatorKey.currentContext!).location;

    if (location == notes.path) {
      return notes;
    } else if (location == editor.fullPath) {
      return editor;
    } else if (location == bin.path) {
      return bin;
    } else if (location == settings.path) {
      return settings;
    } else if (location == settingsAppearance.fullPath) {
      return settingsAppearance;
    } else if (location == settingsBehavior.fullPath) {
      return settingsBehavior;
    } else if (location == settingsEditor.fullPath) {
      return settingsEditor;
    } else if (location == settingsBackup.fullPath) {
      return settingsBackup;
    } else if (location == settingsAbout.fullPath) {
      return settingsAbout;
    } else {
      throw Exception('Unexpected current route: $location');
    }
  }

  /// Whether the current route of the application is the [bin].
  static bool get isBin => currentRoute == bin;

  /// Whether the current route of the application is the [editor].
  static bool get isEditor => currentRoute == editor;
}
