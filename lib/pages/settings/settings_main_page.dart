import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:settings_tiles/settings_tiles.dart';

import '../../common/constants/paddings.dart';
import '../../common/extensions/build_context_extension.dart';
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
      appBar: TopNavigation(appbar: BasicAppBar(title: context.l.navigation_settings)),
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
                    title: context.l.settings_page_appearance,
                    description: context.l.settings_page_appearance_description,
                    onTap: () => context.goNamed(NavigationRoute.settingsAppearance.name),
                  ),
                  SettingActionTile(
                    icon: Icons.dashboard,
                    title: context.l.settings_page_notes_tiles,
                    description: context.l.settings_page_notes_tiles_description,
                    onTap: () => context.goNamed(NavigationRoute.settingsNotesTiles.name),
                  ),
                  SettingActionTile(
                    icon: Icons.swipe,
                    title: context.l.settings_behavior,
                    description: context.l.settings_behavior_description,
                    onTap: () => context.goNamed(NavigationRoute.settingsBehavior.name),
                  ),
                  SettingActionTile(
                    icon: Icons.category,
                    title: context.l.settings_page_notes_types,
                    description: context.l.settings_page_notes_types_description,
                    onTap: () => context.goNamed(NavigationRoute.settingsNotesTypes.name),
                  ),
                  SettingActionTile(
                    icon: Icons.edit,
                    title: context.l.settings_editor,
                    description: context.l.settings_editor_description,
                    onTap: () => context.goNamed(NavigationRoute.settingsEditor.name),
                  ),
                  SettingActionTile(
                    icon: Icons.label,
                    title: context.l.settings_labels,
                    description: context.l.settings_labels_description,
                    onTap: () => context.goNamed(NavigationRoute.settingsLabels.name),
                  ),
                  SettingActionTile(
                    icon: Icons.settings_backup_restore,
                    title: context.l.settings_backup,
                    description: context.l.settings_backup_description,
                    onTap: () => context.goNamed(NavigationRoute.settingsBackup.name),
                  ),
                  SettingActionTile(
                    icon: Icons.security,
                    title: context.l.settings_security,
                    description: context.l.settings_security_description,
                    onTap: () => context.goNamed(NavigationRoute.settingsSecurity.name),
                  ),
                  SettingActionTile(
                    icon: Icons.accessibility,
                    title: context.l.settings_accessibility,
                    description: context.l.settings_accessibility_description,
                    onTap: () => context.goNamed(NavigationRoute.settingsAccessibility.name),
                  ),
                  SettingActionTile(
                    icon: Icons.help,
                    title: context.l.settings_help,
                    description: context.l.settings_help_description,
                    onTap: () => context.goNamed(NavigationRoute.settingsHelp.name),
                  ),
                  SettingActionTile(
                    icon: Icons.info,
                    title: context.l.settings_about,
                    description: context.l.settings_about_description,
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
