import 'package:go_router/go_router.dart';
import 'package:localmaterialnotes/utils/constants/constants.dart';
import 'package:localmaterialnotes/utils/extensions/go_router_extension.dart';

enum RouterRoute {
  notes('/notes'),
  editor('editor', '/notes/editor'),
  bin('/bin'),
  settings('/settings'),
  ;

  final String path;
  final String? fullPath;

  const RouterRoute(this.path, [this.fullPath]);

  String get title {
    switch (this) {
      case RouterRoute.notes:
        return localizations.navigation_notes;
      case RouterRoute.bin:
        return localizations.navigation_bin;
      case RouterRoute.settings:
        return localizations.navigation_settings;
      default:
        throw Exception('Unexpected route: $this');
    }
  }

  static RouterRoute get currentRoute {
    final location = GoRouter.of(navigatorKey.currentContext!).location();

    if (location == RouterRoute.notes.path) {
      return RouterRoute.notes;
    } else if (location.contains(RouterRoute.editor.path)) {
      return RouterRoute.editor;
    } else if (location == RouterRoute.bin.path) {
      return RouterRoute.bin;
    } else if (location == RouterRoute.settings.path) {
      return RouterRoute.settings;
    } else {
      return RouterRoute.notes;
    }
  }

  static bool get isBin => RouterRoute.currentRoute == RouterRoute.bin;

  static bool get isEditor => RouterRoute.currentRoute == RouterRoute.editor;
}
