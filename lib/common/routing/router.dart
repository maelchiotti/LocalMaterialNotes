import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:localmaterialnotes/common/fabs/fab_add_note.dart';
import 'package:localmaterialnotes/common/fabs/fab_empty_bin.dart';
import 'package:localmaterialnotes/common/navigation/side_navigation.dart';
import 'package:localmaterialnotes/common/navigation/top_navigation.dart';
import 'package:localmaterialnotes/common/routing/editor_parameters.dart';
import 'package:localmaterialnotes/common/routing/router_route.dart';
import 'package:localmaterialnotes/pages/bin/bin_page.dart';
import 'package:localmaterialnotes/pages/editor/editor_page.dart';
import 'package:localmaterialnotes/pages/notes/notes_page.dart';
import 'package:localmaterialnotes/pages/settings/settings_page.dart';
import 'package:localmaterialnotes/utils/constants/constants.dart';

CustomTransitionPage _getCustomTransitionPage<T>(GoRouterState state, Widget child) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(opacity: animation, child: child);
    },
  );
}

Page<dynamic> Function(BuildContext, GoRouterState) _defaultPageBuilder<T>(Widget child) {
  return (BuildContext context, GoRouterState state) {
    return _getCustomTransitionPage(state, child);
  };
}

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
          drawer: const SideNavigation(),
          body: child,
          floatingActionButton: _getFloatingActionButton(context),
        );
      },
      routes: [
        GoRoute(
          path: RouterRoute.notes.path,
          pageBuilder: _defaultPageBuilder(const NotesPage()),
          routes: [
            GoRoute(
              path: RouterRoute.editor.path,
              pageBuilder: (context, state) {
                final parameters = state.extra as EditorParameters;

                return _getCustomTransitionPage(
                  state,
                  EditorPage(
                    readOnly: parameters?['readonly'] ?? false,
                    autofocus: parameters?['autofocus'] ?? false,
                  ),
                );
              },
            ),
          ],
        ),
        GoRoute(
          path: RouterRoute.bin.path,
          pageBuilder: _defaultPageBuilder(const BinPage()),
        ),
        GoRoute(
          path: RouterRoute.settings.path,
          pageBuilder: _defaultPageBuilder(const SettingsPage()),
        ),
      ],
    ),
  ],
);
