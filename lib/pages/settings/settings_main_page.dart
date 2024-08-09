import 'package:flutter/material.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:localmaterialnotes/common/routing/router_route.dart';
import 'package:localmaterialnotes/pages/settings/enums/settings_page.dart';
import 'package:localmaterialnotes/pages/settings/widgets/custom_settings_list.dart';
import 'package:localmaterialnotes/utils/constants/constants.dart';

/// Page for the settings of the application.
class SettingsMainPage extends StatefulWidget {
  const SettingsMainPage();

  @override
  State<SettingsMainPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsMainPage> {
  void _openSettingsPage(SettingsPage page) {
    switch (page) {
      case SettingsPage.appearance:
        context.push(RouterRoute.settingsAppearance.fullPath!);
      case SettingsPage.behavior:
        context.push(RouterRoute.settingsBehavior.fullPath!);
      case SettingsPage.editor:
        context.push(RouterRoute.settingsEditor.fullPath!);
      case SettingsPage.backup:
        context.push(RouterRoute.settingsBackup.fullPath!);
      case SettingsPage.about:
        context.push(RouterRoute.settingsAbout.fullPath!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomSettingsList(
      sections: [
        SettingsSection(
          tiles: [
            SettingsTile.navigation(
              leading: const Icon(Icons.palette),
              title: Text(localizations.settings_appearance),
              description: Text(localizations.settings_appearance_description),
              onPressed: (_) => _openSettingsPage(SettingsPage.appearance),
            ),
            SettingsTile.navigation(
              leading: const Icon(Icons.swipe),
              title: Text(localizations.settings_behavior),
              description: Text(localizations.settings_behavior_description),
              onPressed: (_) => _openSettingsPage(SettingsPage.behavior),
            ),
            SettingsTile.navigation(
              leading: const Icon(Icons.format_color_text),
              title: Text(localizations.settings_editor),
              description: Text(localizations.settings_editor_description),
              onPressed: (_) => _openSettingsPage(SettingsPage.editor),
            ),
            SettingsTile.navigation(
              leading: const Icon(Icons.settings_backup_restore),
              title: Text(localizations.settings_backup),
              description: Text(localizations.settings_backup_description),
              onPressed: (_) => _openSettingsPage(SettingsPage.backup),
            ),
            SettingsTile.navigation(
              leading: const Icon(Icons.info),
              title: Text(localizations.settings_about),
              description: Text(localizations.settings_about_description),
              onPressed: (_) => _openSettingsPage(SettingsPage.about),
            ),
          ],
        ),
      ],
    );
  }
}
