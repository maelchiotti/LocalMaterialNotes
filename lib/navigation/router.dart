import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../common/constants/constants.dart';
import '../common/extensions/build_context_extension.dart';
import '../common/preferences/preference_key.dart';
import '../common/types.dart';
import '../models/label/label.dart';
import '../pages/archives/archives_page.dart';
import '../pages/bin/bin_page.dart';
import '../pages/editor/editor_page.dart';
import '../pages/labels/labels_page.dart';
import '../pages/lock/lock_page.dart';
import '../pages/notes/notes_page.dart';
import '../pages/settings/pages/settings_about_page.dart';
import '../pages/settings/pages/settings_accessibility_page.dart';
import '../pages/settings/pages/settings_appearance_page.dart';
import '../pages/settings/pages/settings_backup_page.dart';
import '../pages/settings/pages/settings_behavior_page.dart';
import '../pages/settings/pages/settings_editor_page.dart';
import '../pages/settings/pages/settings_help_page.dart';
import '../pages/settings/pages/settings_labels_page.dart';
import '../pages/settings/pages/settings_notes_tiles_page.dart';
import '../pages/settings/pages/settings_notes_types_page.dart';
import '../pages/settings/pages/settings_security_page.dart';
import '../pages/settings/settings_main_page.dart';
import '../providers/notifiers/notifiers.dart';
import 'navigation_routes.dart';

/// The application router configuration.
final router = GoRouter.routingConfig(
  navigatorKey: rootNavigatorKey,
  refreshListenable: lockAppNotifier,
  initialLocation: NavigationRoute.notes.path,
  routingConfig: routingConfig,
);

/// The router redirection function.
String? goRouterRedirect(BuildContext context, GoRouterState state) {
  final lockApp = PreferenceKey.lockApp.preferenceOrDefault;
  final isLocked = lockAppNotifier.value;

  if (!lockApp) {
    return null;
  }

  if (isLocked && state.matchedLocation != NavigationRoute.lock.path) {
    return NavigationRoute.lock.path;
  }

  if (!isLocked && state.matchedLocation == NavigationRoute.lock.path) {
    return NavigationRoute.notes.path;
  }

  return null;
}

/// The lock route.
final lockRoute = GoRoute(
  name: NavigationRoute.lock.name,
  path: NavigationRoute.lock.path,
  builder: (context, state) {
    return LockPage(
      back: false,
      lockNotifier: lockAppNotifier,
      description: context.l.lock_page_description_app,
      reason: context.l.lock_page_reason_app,
    );
  },
);

/// The default notes route.
final defaultNotesRoute = GoRoute(
  name: NavigationRoute.notes.name,
  path: NavigationRoute.notes.path,
  builder: (context, state) {
    final label = state.extra as Label?;

    return NotesPage(label: label);
  },
  routes: [
    GoRoute(
      name: NavigationRoute.labels.name,
      path: NavigationRoute.labels.path,
      builder: (context, state) => LabelsPage(),
    ),
    GoRoute(
      name: NavigationRoute.archives.name,
      path: NavigationRoute.archives.path,
      builder: (context, state) => ArchivesPage(),
    ),
    GoRoute(name: NavigationRoute.bin.name, path: NavigationRoute.bin.path, builder: (context, state) => BinPage()),
    GoRoute(
      name: NavigationRoute.settings.name,
      path: NavigationRoute.settings.path,
      builder: (context, state) => SettingsMainPage(),
      routes: [
        GoRoute(
          name: NavigationRoute.settingsAppearance.name,
          path: NavigationRoute.settingsAppearance.path,
          builder: (context, state) => SettingsAppearancePage(),
        ),
        GoRoute(
          name: NavigationRoute.settingsNotesTiles.name,
          path: NavigationRoute.settingsNotesTiles.path,
          builder: (context, state) => SettingsNotesTilesPage(),
        ),
        GoRoute(
          name: NavigationRoute.settingsBehavior.name,
          path: NavigationRoute.settingsBehavior.path,
          builder: (context, state) => SettingsBehaviorPage(),
        ),
        GoRoute(
          name: NavigationRoute.settingsNotesTypes.name,
          path: NavigationRoute.settingsNotesTypes.path,
          builder: (context, state) => SettingsNotesTypesPage(),
        ),
        GoRoute(
          name: NavigationRoute.settingsEditor.name,
          path: NavigationRoute.settingsEditor.path,
          builder: (context, state) => SettingsEditorPage(),
        ),
        GoRoute(
          name: NavigationRoute.settingsLabels.name,
          path: NavigationRoute.settingsLabels.path,
          builder: (context, state) => SettingsLabelsPage(),
        ),
        GoRoute(
          name: NavigationRoute.settingsBackup.name,
          path: NavigationRoute.settingsBackup.path,
          builder: (context, state) => SettingsBackupPage(),
        ),
        GoRoute(
          name: NavigationRoute.settingsSecurity.name,
          path: NavigationRoute.settingsSecurity.path,
          builder: (context, state) => SettingsSecurityPage(),
        ),
        GoRoute(
          name: NavigationRoute.settingsAccessibility.name,
          path: NavigationRoute.settingsAccessibility.path,
          builder: (context, state) => SettingsAccessibilityPage(),
        ),
        GoRoute(
          name: NavigationRoute.settingsHelp.name,
          path: NavigationRoute.settingsHelp.path,
          builder: (context, state) => SettingsHelpPage(),
        ),
        GoRoute(
          name: NavigationRoute.settingsAbout.name,
          path: NavigationRoute.settingsAbout.path,
          builder: (context, state) => SettingsAboutPage(),
        ),
      ],
    ),
  ],
);

/// The editor route.
final editorRoute = GoRoute(
  name: NavigationRoute.editor.name,
  path: NavigationRoute.editor.path,
  builder: (context, state) {
    final extras = state.extra as EditorPageExtra;

    return EditorPage(readOnly: extras.readOnly, isNewNote: extras.isNewNote);
  },
);

/// The router routing configuration.
final routingConfig = ValueNotifier(
  RoutingConfig(redirect: goRouterRedirect, routes: [lockRoute, defaultNotesRoute, editorRoute]),
);
