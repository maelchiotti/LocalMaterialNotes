import 'package:collection/collection.dart';
import 'package:go_router/go_router.dart';
import 'package:localmaterialnotes/utils/constants/constants.dart';
import 'package:localmaterialnotes/utils/extensions/go_router_extension.dart';

enum RouterRoute {
  notes('/notes', drawerIndex: 0),
  editor('editor', fullPath: '/notes/editor'),
  bin('/bin', drawerIndex: 1),
  settings('/settings', drawerIndex: 2),
  ;

  final String path;
  final String? fullPath;
  final int? drawerIndex;

  const RouterRoute(this.path, {this.fullPath, this.drawerIndex});

  String get title {
    switch (this) {
      case notes:
        return localizations.navigation_notes;
      case bin:
        return localizations.navigation_bin;
      case settings:
        return localizations.navigation_settings;
      default:
        throw Exception('Unexpected route: $this');
    }
  }

  static int get currentDrawerIndex {
    final drawerIndex = currentRoute.drawerIndex;

    if (drawerIndex == null) throw Exception('No current drawer index');

    return drawerIndex;
  }

  static RouterRoute getRouteFromIndex(int index) {
    final route = values.firstWhereOrNull((route) => route.drawerIndex == index);

    if (route == null) throw Exception('No route for index: $index');

    return route;
  }

  static RouterRoute get currentRoute {
    final location = GoRouter.of(navigatorKey.currentContext!).location();

    if (location == notes.path) {
      return notes;
    } else if (location.contains(editor.path)) {
      return editor;
    } else if (location == bin.path) {
      return bin;
    } else if (location == settings.path) {
      return settings;
    } else {
      throw Exception('Unexpected route: $location');
    }
  }

  static bool get isBin => currentRoute == bin;

  static bool get isEditor => currentRoute == editor;
}
