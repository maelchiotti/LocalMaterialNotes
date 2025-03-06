import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:settings_tiles/settings_tiles.dart';

import '../../common/constants/constants.dart';
import '../../common/constants/paddings.dart';
import '../../common/navigation/app_bars/basic_app_bar.dart';
import '../../common/navigation/side_navigation.dart';
import '../../common/navigation/top_navigation.dart';
import '../../navigation/navigation_routes.dart';

/// Page for the settings of the application.
class SettingsMainPage extends StatelessWidget {
  /// Default constructor.
  const SettingsMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopNavigation(appbar: BasicAppBar(title: l.navigation_settings)),
      drawer: const SideNavigation(),
      body: SingleChildScrollView(
        child: Padding(
          padding: Paddings.bottomSystemUi,
          child: Column(
            children: [
              SettingSection(
                divider: null,
                tiles: [
                  SettingActionTile(
                    icon: Icons.palette,
                    title: l.settings_page_appearance,
                    description: l.settings_page_appearance_description,
                    onTap: () => context.goNamed(NavigationRoute.settingsAppearance.name),
                  ),
                  SettingActionTile(
                    icon: Icons.dashboard,
                    title: l.settings_page_notes_tiles,
                    description: l.settings_page_notes_tiles_description,
                    onTap: () => context.goNamed(NavigationRoute.settingsNotesTiles.name),
                  ),
                  SettingActionTile(
                    icon: Icons.swipe,
                    title: l.settings_behavior,
                    description: l.settings_behavior_description,
                    onTap: () => context.goNamed(NavigationRoute.settingsBehavior.name),
                  ),
                  SettingActionTile(
                    icon: Icons.category,
                    title: l.settings_page_notes_types,
                    description: l.settings_page_notes_types_description,
                    onTap: () => context.goNamed(NavigationRoute.settingsNotesTypes.name),
                  ),
                  SettingActionTile(
                    icon: Icons.edit,
                    title: l.settings_editor,
                    description: l.settings_editor_description,
                    onTap: () => context.goNamed(NavigationRoute.settingsEditor.name),
                  ),
                  SettingActionTile(
                    icon: Icons.label,
                    title: l.settings_labels,
                    description: l.settings_labels_description,
                    onTap: () => context.goNamed(NavigationRoute.settingsLabels.name),
                  ),
                  SettingActionTile(
                    icon: Icons.settings_backup_restore,
                    title: l.settings_backup,
                    description: l.settings_backup_description,
                    onTap: () => context.goNamed(NavigationRoute.settingsBackup.name),
                  ),
                  SettingActionTile(
                    icon: Icons.security,
                    title: l.settings_security,
                    description: l.settings_security_description,
                    onTap: () => context.goNamed(NavigationRoute.settingsSecurity.name),
                  ),
                  SettingActionTile(
                    icon: Icons.accessibility,
                    title: l.settings_accessibility,
                    description: l.settings_accessibility_description,
                    onTap: () => context.goNamed(NavigationRoute.settingsAccessibility.name),
                  ),
                  SettingActionTile(
                    icon: Icons.help,
                    title: l.settings_help,
                    description: l.settings_help_description,
                    onTap: () => context.goNamed(NavigationRoute.settingsHelp.name),
                  ),
                  SettingActionTile(
                    icon: Icons.info,
                    title: l.settings_about,
                    description: l.settings_about_description,
                    onTap: () => context.goNamed(NavigationRoute.settingsAbout.name),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
