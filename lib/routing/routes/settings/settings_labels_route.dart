import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:localmaterialnotes/pages/settings/pages/settings_labels_page.dart';

/// Route of the settings labels page.
@immutable
class SettingsLabelsRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const SettingsLabelsPage();
  }
}
