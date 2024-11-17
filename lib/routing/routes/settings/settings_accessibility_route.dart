import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:localmaterialnotes/pages/settings/pages/settings_accessibility_page.dart';

/// Route of the settings accessibility page.
@immutable
class SettingsAccessibilityRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const SettingsAccessibilityPage();
  }
}
