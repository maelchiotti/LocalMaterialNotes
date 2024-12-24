import 'package:flutter/material.dart';
import '../../common/constants/constants.dart';
import '../../common/navigation/app_bars/basic_app_bar.dart';
import '../../common/navigation/side_navigation.dart';
import '../../common/navigation/top_navigation.dart';
import '../../navigation/navigation_routes.dart';
import 'pages/settings_about_page.dart';
import 'pages/settings_accessibility_page.dart';
import 'pages/settings_appearance_page.dart';
import 'pages/settings_backup_page.dart';
import 'pages/settings_behavior_page.dart';
import 'pages/settings_editor_page.dart';
import 'pages/settings_labels_page.dart';
import '../../utils/keys.dart';
import 'package:settings_tiles/settings_tiles.dart';

/// Page for the settings of the application.
class SettingsMainPage extends StatelessWidget {
  /// Default constructor.
  const SettingsMainPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: TopNavigation(
          key: Keys.appBarSettingsMain,
          appbar: BasicAppBar(
            title: l.navigation_settings,
            //back: true,
          ),
        ),
        drawer: const SideNavigation(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SettingSection(
                divider: null,
                tiles: [
                  SettingActionTile(
                    icon: Icons.palette,
                    title: l.settings_page_appearance,
                    description: l.settings_page_appearance_description,
                    onTap: () => NavigationRoute.settingsAppearance.push(context, SettingsAppearancePage()),
                  ),
                  SettingActionTile(
                    icon: Icons.swipe,
                    title: l.settings_behavior,
                    description: l.settings_behavior_description,
                    onTap: () => NavigationRoute.settingsBehavior.push(context, SettingsBehaviorPage()),
                  ),
                  SettingActionTile(
                    icon: Icons.format_color_text,
                    title: l.settings_editor,
                    description: l.settings_editor_description,
                    onTap: () => NavigationRoute.settingsEditor.push(context, SettingsEditorPage()),
                  ),
                  SettingActionTile(
                    icon: Icons.label,
                    title: l.settings_labels,
                    description: l.settings_labels_description,
                    onTap: () => NavigationRoute.settingsLabels.push(context, SettingsLabelsPage()),
                  ),
                  SettingActionTile(
                    icon: Icons.settings_backup_restore,
                    title: l.settings_backup,
                    description: l.settings_backup_description,
                    onTap: () => NavigationRoute.settingsBackup.push(context, SettingsBackupPage()),
                  ),
                  SettingActionTile(
                    icon: Icons.accessibility,
                    title: l.settings_accessibility,
                    description: l.settings_accessibility_description,
                    onTap: () => NavigationRoute.settingsAccessibility.push(context, SettingsAccessibilityPage()),
                  ),
                  SettingActionTile(
                    icon: Icons.info,
                    title: l.settings_about,
                    description: l.settings_about_description,
                    onTap: () => NavigationRoute.settingsAbout.push(context, SettingsAboutPage()),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
}
