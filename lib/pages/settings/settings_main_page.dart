import 'package:flutter/material.dart';
import 'package:localmaterialnotes/common/constants/constants.dart';
import 'package:localmaterialnotes/common/navigation/app_bars/basic_app_bar.dart';
import 'package:localmaterialnotes/common/navigation/side_navigation.dart';
import 'package:localmaterialnotes/common/navigation/top_navigation.dart';
import 'package:localmaterialnotes/routing/routes/settings/settings_about_route.dart';
import 'package:localmaterialnotes/routing/routes/settings/settings_accessibility_route.dart';
import 'package:localmaterialnotes/routing/routes/settings/settings_appearance_route.dart';
import 'package:localmaterialnotes/routing/routes/settings/settings_backup_route.dart';
import 'package:localmaterialnotes/routing/routes/settings/settings_behavior_route.dart';
import 'package:localmaterialnotes/routing/routes/settings/settings_editor_route.dart';
import 'package:localmaterialnotes/routing/routes/settings/settings_labels_route.dart';
import 'package:localmaterialnotes/routing/routes/shell/shell_route.dart';
import 'package:localmaterialnotes/utils/keys.dart';
import 'package:settings_tiles/settings_tiles.dart';

/// Page for the settings of the application.
class SettingsMainPage extends StatelessWidget {
  /// Default constructor.
  const SettingsMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TopNavigation(
        key: Keys.appBarSettingsMain,
        appbar: BasicAppBar(),
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
                  onTap: () => SettingsAppearanceRoute().push<void>(context),
                ),
                SettingActionTile(
                  icon: Icons.swipe,
                  title: l.settings_behavior,
                  description: l.settings_behavior_description,
                  onTap: () => SettingsBehaviorRoute().push<void>(context),
                ),
                SettingActionTile(
                  icon: Icons.format_color_text,
                  title: l.settings_editor,
                  description: l.settings_editor_description,
                  onTap: () => SettingsEditorRoute().push<void>(context),
                ),
                SettingActionTile(
                  icon: Icons.label,
                  title: l.settings_labels,
                  description: l.settings_labels_description,
                  onTap: () => SettingsLabelsRoute().push<void>(context),
                ),
                SettingActionTile(
                  icon: Icons.settings_backup_restore,
                  title: l.settings_backup,
                  description: l.settings_backup_description,
                  onTap: () => SettingsBackupRoute().push<void>(context),
                ),
                SettingActionTile(
                  icon: Icons.accessibility,
                  title: l.settings_accessibility,
                  description: l.settings_accessibility_description,
                  onTap: () => SettingsAccessibilityRoute().push<void>(context),
                ),
                SettingActionTile(
                  icon: Icons.info,
                  title: l.settings_about,
                  description: l.settings_about_description,
                  onTap: () => SettingsAboutRoute().push<void>(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
