import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:settings_tiles/settings_tiles.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../common/constants/constants.dart';
import '../../../common/constants/paddings.dart';
import '../../../common/navigation/app_bars/basic_app_bar.dart';
import '../../../common/navigation/top_navigation.dart';
import '../../../common/system_utils.dart';

/// Settings providing help.
class SettingsHelpPage extends StatelessWidget {
  /// Default constructor.
  const SettingsHelpPage({super.key});

  /// Opens the application's GitHub issues.
  void openGitHubIssues() {
    launchUrl(
      Uri(
        scheme: 'https',
        host: 'github.com',
        path: 'maelchiotti/LocalMaterialNotes/issues',
      ),
    );
  }

  /// Opens the application's GitHub discussions.
  void openGitHubDiscussions() {
    launchUrl(
      Uri(
        scheme: 'https',
        host: 'github.com',
        path: 'maelchiotti/LocalMaterialNotes/discussions',
      ),
    );
  }

  /// Sends an email to the contact email with some basic information.
  void sendMail() {
    final systemUtils = SystemUtils();

    final appVersion = systemUtils.appVersion;
    final buildMode = systemUtils.buildMode;
    final androidVersion = systemUtils.androidVersion;
    final brand = systemUtils.brand;
    final model = systemUtils.model;

    launchUrl(
      Uri(
        scheme: 'mailto',
        path: contactEmail,
        query: systemUtils.encodeQueryParameters({
          'subject': '[Material Notes] ',
          'body': '\n\n\n----------\nv$appVersion\n$buildMode mode\nAndroid $androidVersion\n$brand $model',
        }),
      ),
    );
  }

  /// Copies the logs to the clipboard.
  Future<void> copyLogs() async {
    await logger.copyLogs();
  }

  /// Exports the logs to a file.
  Future<void> exportLogs() async {
    await logger.exportLogs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopNavigation(
        appbar: BasicAppBar(title: l.navigation_settings_help),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: Paddings.bottomSystemUi,
          child: Column(
            children: [
              SettingSection(
                divider: null,
                title: l.settings_help_section_contact,
                tiles: [
                  SettingActionTile(
                    icon: Icons.bug_report,
                    title: l.settings_github_issues,
                    description: l.settings_github_issues_description,
                    onTap: openGitHubIssues,
                  ),
                  SettingActionTile(
                    icon: Icons.forum,
                    title: l.settings_github_discussions,
                    description: l.settings_github_discussions_description,
                    onTap: openGitHubDiscussions,
                  ),
                  SettingActionTile(
                    icon: Icons.mail,
                    title: l.settings_contact_developer,
                    description: l.settings_get_in_touch_description(contactEmail),
                    onTap: sendMail,
                  ),
                ],
              ),
              SettingSection(
                divider: null,
                title: l.settings_help_section_logs,
                tiles: [
                  SettingActionTile(
                    icon: Icons.copy_all,
                    title: l.settings_copy_logs,
                    description: l.settings_copy_logs_description,
                    onTap: copyLogs,
                  ),
                  SettingActionTile(
                    icon: Symbols.file_save,
                    title: l.settings_export_logs,
                    description: l.settings_export_logs_description,
                    onTap: exportLogs,
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
