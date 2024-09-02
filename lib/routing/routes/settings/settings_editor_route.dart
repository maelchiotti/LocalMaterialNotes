import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:localmaterialnotes/pages/settings/pages/settings_editor_page.dart';

@immutable
class SettingsEditorRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const SettingsEditorPage();
  }
}
