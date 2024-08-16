import 'package:go_router/go_router.dart';

/// Extends the [GoRouter] class with some utilities functions.
extension GoRouterExtension on GoRouter {
  /// Returns the path of the current location of the application's router.
  String get location {
    final lastMatch = routerDelegate.currentConfiguration.last;
    final matchList = lastMatch is ImperativeRouteMatch ? lastMatch.matches : routerDelegate.currentConfiguration;
    final location = matchList.uri.toString();

    return location;
  }
}
