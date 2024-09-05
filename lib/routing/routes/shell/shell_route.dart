import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:localmaterialnotes/common/constants/constants.dart';
import 'package:localmaterialnotes/pages/shell/shell.dart';
import 'package:localmaterialnotes/routing/routes/bin/bin_route.dart';
import 'package:localmaterialnotes/routing/routes/notes/notes_editor_route.dart';
import 'package:localmaterialnotes/routing/routes/notes/notes_route.dart';
import 'package:localmaterialnotes/routing/routes/settings/settings_about_route.dart';
import 'package:localmaterialnotes/routing/routes/settings/settings_appearance_route.dart';
import 'package:localmaterialnotes/routing/routes/settings/settings_backup_route.dart';
import 'package:localmaterialnotes/routing/routes/settings/settings_behavior_route.dart';
import 'package:localmaterialnotes/routing/routes/settings/settings_editor_route.dart';
import 'package:localmaterialnotes/routing/routes/settings/settings_route.dart';

part 'shell_route.g.dart';

/// Route of the shell page.
@TypedShellRoute<ShellRoute>(
  routes: [
    TypedGoRoute<NotesRoute>(
      path: '/notes',
      routes: [
        TypedGoRoute<NotesEditorRoute>(
          path: 'editor',
        ),
      ],
    ),
    TypedGoRoute<BinRoute>(path: '/bin'),
    TypedGoRoute<SettingsRoute>(
      path: '/settings',
      routes: [
        TypedGoRoute<SettingsAppearanceRoute>(
          path: 'appearance',
        ),
        TypedGoRoute<SettingsBehaviorRoute>(
          path: 'behavior',
        ),
        TypedGoRoute<SettingsEditorRoute>(
          path: 'editor',
        ),
        TypedGoRoute<SettingsBackupRoute>(
          path: 'backup',
        ),
        TypedGoRoute<SettingsAboutRoute>(
          path: 'about',
        ),
      ],
    ),
  ],
)
class ShellRoute extends ShellRouteData {
  /// Key used for navigation.
  static final GlobalKey<NavigatorState> $navigatorKey = shellNavigatorKey;

  @override
  Widget builder(BuildContext context, GoRouterState state, Widget navigator) {
    return ShellPage(child: navigator);
  }
}
