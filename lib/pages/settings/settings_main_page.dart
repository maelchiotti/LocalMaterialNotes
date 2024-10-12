import 'package:flutter/material.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';
import 'package:localmaterialnotes/common/constants/constants.dart';
import 'package:localmaterialnotes/common/widgets/navigation/app_bars/basic_app_bar.dart';
import 'package:localmaterialnotes/common/widgets/navigation/side_navigation.dart';
import 'package:localmaterialnotes/common/widgets/navigation/top_navigation.dart';
import 'package:localmaterialnotes/pages/settings/widgets/custom_settings_list.dart';
import 'package:localmaterialnotes/routing/routes/settings/settings_about_route.dart';
import 'package:localmaterialnotes/routing/routes/settings/settings_appearance_route.dart';
import 'package:localmaterialnotes/routing/routes/settings/settings_backup_route.dart';
import 'package:localmaterialnotes/routing/routes/settings/settings_behavior_route.dart';
import 'package:localmaterialnotes/routing/routes/settings/settings_editor_route.dart';
import 'package:localmaterialnotes/routing/routes/shell/shell_route.dart';
import 'package:localmaterialnotes/utils/keys.dart';

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
      body: CustomSettingsList(
        sections: [
          SettingsSection(
            tiles: [
              SettingsTile.navigation(
                leading: const Icon(Icons.palette),
                title: Text(localizations.settings_appearance),
                description: Text(localizations.settings_appearance_description),
                onPressed: _openAppearancePage,
              ),
              SettingsTile.navigation(
                leading: const Icon(Icons.swipe),
                title: Text(localizations.settings_behavior),
                description: Text(localizations.settings_behavior_description),
                onPressed: _openBehaviorPage,
              ),
              SettingsTile.navigation(
                leading: const Icon(Icons.format_color_text),
                title: Text(localizations.settings_editor),
                description: Text(localizations.settings_editor_description),
                onPressed: _openEditorPage,
              ),
              SettingsTile.navigation(
                leading: const Icon(Icons.settings_backup_restore),
                title: Text(localizations.settings_backup),
                description: Text(localizations.settings_backup_description),
                onPressed: _openBackupPage,
              ),
              SettingsTile.navigation(
                leading: const Icon(Icons.info),
                title: Text(localizations.settings_about),
                description: Text(localizations.settings_about_description),
                onPressed: _openAboutPage,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
