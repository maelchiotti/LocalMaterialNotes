import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:localmaterialnotes/pages/settings/pages/settings_appearance_page.dart';

@immutable
class SettingsAppearanceRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const SettingsAppearancePage();
  }
}
