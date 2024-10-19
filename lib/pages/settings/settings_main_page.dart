import 'package:flutter/material.dart';
import 'package:localmaterialnotes/common/constants/constants.dart';
import 'package:localmaterialnotes/common/navigation/app_bars/basic_app_bar.dart';
import 'package:localmaterialnotes/common/navigation/side_navigation.dart';
import 'package:localmaterialnotes/common/navigation/top_navigation.dart';
import 'package:localmaterialnotes/routing/routes/settings/settings_about_route.dart';
import 'package:localmaterialnotes/routing/routes/settings/settings_appearance_route.dart';
import 'package:localmaterialnotes/routing/routes/settings/settings_backup_route.dart';
import 'package:localmaterialnotes/routing/routes/settings/settings_behavior_route.dart';
import 'package:localmaterialnotes/routing/routes/settings/settings_editor_route.dart';
import 'package:localmaterialnotes/routing/routes/shell/shell_route.dart';
import 'package:localmaterialnotes/utils/keys.dart';
import 'package:settings_tiles/settings_tiles.dart';

/// Page for the settings of the application.
class SettingsMainPage extends StatelessWidget {
  /// Default constructor.
  const SettingsMainPage({super.key});

  void _openAppearancePage(BuildContext context) {
    SettingsAppearanceRoute().push(context);
  }

  void _openBehaviorPage(BuildContext context) {
    SettingsBehaviorRoute().push(context);
  }

  void _openEditorPage(BuildContext context) {
    SettingsEditorRoute().push(context);
  }

  void _openBackupPage(BuildContext context) {
    SettingsBackupRoute().push(context);
  }

  void _openAboutPage(BuildContext context) {
    SettingsAboutRoute().push(context);
  }

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
                  onTap: () => _openAppearancePage(context),
                ),
                SettingActionTile(
                  icon: Icons.swipe,
                  title: l.settings_behavior,
                  description: l.settings_behavior_description,
                  onTap: () => _openBehaviorPage(context),
                ),
                SettingActionTile(
                  icon: Icons.format_color_text,
                  title: l.settings_editor,
                  description: l.settings_editor_description,
                  onTap: () => _openEditorPage(context),
                ),
                SettingActionTile(
                  icon: Icons.settings_backup_restore,
                  title: l.settings_backup,
                  description: l.settings_backup_description,
                  onTap: () => _openBackupPage(context),
                ),
                SettingActionTile(
                  icon: Icons.info,
                  title: l.settings_about,
                  description: l.settings_about_description,
                  onTap: () => _openAboutPage(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
