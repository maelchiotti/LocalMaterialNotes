import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:localmaterialnotes/pages/settings/pages/settings_behavior_page.dart';

/// Route of the settings behavior page.
@immutable
class SettingsBehaviorRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const SettingsBehaviorPage();
  }
}
