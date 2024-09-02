import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:localmaterialnotes/pages/settings/pages/settings_backup_page.dart';

@immutable
class SettingsBackupRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const SettingsBackupPage();
  }
}
