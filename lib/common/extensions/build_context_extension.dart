import 'package:collection/collection.dart';
import 'package:flutter/material.dart' hide Route;
import 'package:go_router/go_router.dart';
import 'package:localmaterialnotes/routing/routes/routing_route.dart';

/// Extends the [GoRouter] class with some utilities functions.
extension BuildContextExtension on BuildContext {
  /// Returns the path of the current location of the application's router.
  String get location {
    return GoRouterState.of(this).uri.path;
  }

  RoutingRoute get route {
    final route = RoutingRoute.values.firstWhereOrNull((route) {
      return route.path == location;
    });

    assert(route != null);

    return route!;
  }
}
