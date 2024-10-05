import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:localmaterialnotes/pages/settings/settings_main_page.dart';
import 'package:localmaterialnotes/utils/keys.dart';

/// Route of the main settings page.
@immutable
class SettingsRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const SettingsMainPage(
      key: Keys.pageSettingsMain,
    );
  }
}
