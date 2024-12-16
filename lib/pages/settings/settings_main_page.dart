import 'package:flutter/material.dart';
import 'package:localmaterialnotes/common/constants/constants.dart';
import 'package:localmaterialnotes/common/navigation/app_bars/basic_app_bar.dart';
import 'package:localmaterialnotes/common/navigation/side_navigation.dart';
import 'package:localmaterialnotes/common/navigation/top_navigation.dart';
import 'package:localmaterialnotes/navigation/navigation_routes.dart';
import 'package:localmaterialnotes/pages/settings/pages/settings_about_page.dart';
import 'package:localmaterialnotes/pages/settings/pages/settings_accessibility_page.dart';
import 'package:localmaterialnotes/pages/settings/pages/settings_appearance_page.dart';
import 'package:localmaterialnotes/pages/settings/pages/settings_backup_page.dart';
import 'package:localmaterialnotes/pages/settings/pages/settings_behavior_page.dart';
import 'package:localmaterialnotes/pages/settings/pages/settings_editor_page.dart';
import 'package:localmaterialnotes/pages/settings/pages/settings_labels_page.dart';
import 'package:localmaterialnotes/utils/keys.dart';
import 'package:settings_tiles/settings_tiles.dart';

/// Page for the settings of the application.
class SettingsMainPage extends StatelessWidget {
  /// Default constructor.
  const SettingsMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  title: l.settings_appearance,
                  description: l.settings_appearance_description,
                  onTap: () => NavigationRoute.settingsAppearance.push(
                    rootNavigatorKey.currentContext!,
                    SettingsAppearancePage(),
                  ),
                ),
                SettingActionTile(
                  icon: Icons.swipe,
                  title: l.settings_behavior,
                  description: l.settings_behavior_description,
                  onTap: () => NavigationRoute.settingsBehavior.push(
                    rootNavigatorKey.currentContext!,
                    SettingsBehaviorPage(),
                  ),
                ),
                SettingActionTile(
                  icon: Icons.format_color_text,
                  title: l.settings_editor,
                  description: l.settings_editor_description,
                  onTap: () => NavigationRoute.settingsEditor.push(
                    rootNavigatorKey.currentContext!,
                    SettingsEditorPage(),
                  ),
                ),
                SettingActionTile(
                  icon: Icons.label,
                  title: l.settings_labels,
                  description: l.settings_labels_description,
                  onTap: () => NavigationRoute.settingsLabels.push(
                    rootNavigatorKey.currentContext!,
                    SettingsLabelsPage(),
                  ),
                ),
                SettingActionTile(
                  icon: Icons.settings_backup_restore,
                  title: l.settings_backup,
                  description: l.settings_backup_description,
                  onTap: () => NavigationRoute.settingsBackup.push(
                    rootNavigatorKey.currentContext!,
                    SettingsBackupPage(),
                  ),
                ),
                SettingActionTile(
                  icon: Icons.accessibility,
                  title: l.settings_accessibility,
                  description: l.settings_accessibility_description,
                  onTap: () => NavigationRoute.settingsAccessibility.push(
                    rootNavigatorKey.currentContext!,
                    SettingsAccessibilityPage(),
                  ),
                ),
                SettingActionTile(
                  icon: Icons.info,
                  title: l.settings_about,
                  description: l.settings_about_description,
                  onTap: () => NavigationRoute.settingsAbout.push(
                    rootNavigatorKey.currentContext!,
                    SettingsAboutPage(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
