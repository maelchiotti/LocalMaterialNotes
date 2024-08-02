import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:go_router/go_router.dart';
import 'package:localmaterialnotes/common/fabs/fab_add_note.dart';
import 'package:localmaterialnotes/common/fabs/fab_empty_bin.dart';
import 'package:localmaterialnotes/common/navigation/app_bars/basic_app_bar.dart';
import 'package:localmaterialnotes/common/navigation/app_bars/editor_app_bar.dart';
import 'package:localmaterialnotes/common/navigation/app_bars/notes_app_bar.dart';
import 'package:localmaterialnotes/common/navigation/side_navigation.dart';
import 'package:localmaterialnotes/common/navigation/top_navigation.dart';
import 'package:localmaterialnotes/common/routing/router_route.dart';
import 'package:localmaterialnotes/pages/bin/bin_page.dart';
import 'package:localmaterialnotes/pages/editor/editor_page.dart';
import 'package:localmaterialnotes/pages/notes/notes_page.dart';
import 'package:localmaterialnotes/pages/settings/pages/settings_about_page.dart';
import 'package:localmaterialnotes/pages/settings/pages/settings_appearance_page.dart';
import 'package:localmaterialnotes/pages/settings/pages/settings_backup_page.dart';
import 'package:localmaterialnotes/pages/settings/pages/settings_behavior_page.dart';
import 'package:localmaterialnotes/pages/settings/pages/settings_editor_page.dart';
import 'package:localmaterialnotes/pages/settings/settings_main_page.dart';
import 'package:localmaterialnotes/utils/constants/constants.dart';

typedef EditorParameters = Map<String, bool>?;

PreferredSizeWidget? _getAppBar(BuildContext context) {
  switch (RouterRoute.currentRoute) {
    case RouterRoute.notes:
    case RouterRoute.bin:
      return TopNavigation(
        key: UniqueKey(),
        appbar: const NotesAppBar(),
      );
    case RouterRoute.editor:
      return const TopNavigation(
        appbar: EditorAppBar(),
      );
    case RouterRoute.settings:
      return const TopNavigation(
        appbar: BasicAppBar(),
      );
    case RouterRoute.settingsAppearance:
    case RouterRoute.settingsBehavior:
    case RouterRoute.settingsEditor:
    case RouterRoute.settingsBackup:
    case RouterRoute.settingsAbout:
      return const TopNavigation(
        appbar: BasicAppBar.back(),
      );
    default:
      return null;
  }
}

Widget? _getDrawer() {
  if (RouterRoute.currentRoute.drawerIndex == null) {
    return null;
  }

  return const SideNavigation();
}

Widget? _getFloatingActionButton(BuildContext context) {
  switch (RouterRoute.currentRoute) {
    case RouterRoute.notes:
      return const FabAddNote();
    case RouterRoute.bin:
      return const FabEmptyBin();
    default:
      return null;
  }
}

final router = GoRouter(
  navigatorKey: navigatorKey,
  initialLocation: RouterRoute.notes.path,
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return Scaffold(
          key: drawerKey,
          appBar: _getAppBar(context),
          drawer: _getDrawer(),
          body: KeyboardVisibilityProvider(child: child),
          floatingActionButton: _getFloatingActionButton(context),
        );
      },
      routes: [
        GoRoute(
          path: RouterRoute.notes.path,
          builder: (context, state) => const NotesPage(),
          routes: [
            GoRoute(
              path: RouterRoute.editor.path,
              pageBuilder: (context, state) {
                return NoTransitionPage(
                  child: EditorPage(state.extra as EditorParameters),
                );
              },
            ),
          ],
        ),
        GoRoute(
          path: RouterRoute.bin.path,
          builder: (context, state) => const BinPage(),
        ),
        GoRoute(
          path: RouterRoute.settings.path,
          builder: (context, state) => const SettingsMainPage(),
          routes: [
            GoRoute(
              path: RouterRoute.settingsAppearance.path,
              builder: (context, state) => const SettingsAppearancePage(),
            ),
            GoRoute(
              path: RouterRoute.settingsBehavior.path,
              builder: (context, state) => const SettingsBehaviorPage(),
            ),
            GoRoute(
              path: RouterRoute.settingsEditor.path,
              builder: (context, state) => const SettingsEditorPage(),
            ),
            GoRoute(
              path: RouterRoute.settingsBackup.path,
              builder: (context, state) => const SettingsBackupPage(),
            ),
            GoRoute(
              path: RouterRoute.settingsAbout.path,
              builder: (context, state) => const SettingsAboutPage(),
            ),
          ],
        ),
      ],
    ),
  ],
);
