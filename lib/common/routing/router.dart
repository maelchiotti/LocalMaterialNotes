import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:localmaterialnotes/common/fabs/fab_add_note.dart';
import 'package:localmaterialnotes/common/fabs/fab_empty_bin.dart';
import 'package:localmaterialnotes/common/navigation/side_navigation.dart';
import 'package:localmaterialnotes/common/navigation/top_navigation.dart';
import 'package:localmaterialnotes/common/routing/router_route.dart';
import 'package:localmaterialnotes/pages/bin/bin_page.dart';
import 'package:localmaterialnotes/pages/editor/editor_page.dart';
import 'package:localmaterialnotes/pages/notes/notes_page.dart';
import 'package:localmaterialnotes/pages/settings/settings_page.dart';
import 'package:localmaterialnotes/utils/constants/constants.dart';

typedef EditorParameters = Map<String, bool>?;

PreferredSizeWidget? _getAppBar(BuildContext context) {
  switch (RouterRoute.currentRoute) {
    case RouterRoute.notes:
    case RouterRoute.bin:
      return TopNavigation.searchSort(key: UniqueKey());
    case RouterRoute.editor:
      return const TopNavigation.backMenu();
    case RouterRoute.settings:
      return const TopNavigation.empty();
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
          body: child,
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
          builder: (context, state) => const SettingsPage(),
        ),
      ],
    ),
  ],
);
