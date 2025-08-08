import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:settings_tiles/settings_tiles.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../common/constants/constants.dart';
import '../../../common/constants/paddings.dart';
import '../../../common/extensions/build_context_extension.dart';
import '../../../common/navigation/app_bars/basic_app_bar.dart';
import '../../../common/navigation/top_navigation.dart';
import '../../../common/system_utils.dart';

/// Settings providing help.
class SettingsHelpPage extends StatelessWidget {
  /// Default constructor.
  const SettingsHelpPage({super.key});

  /// Opens the application's GitHub issues.
  void openGitHubIssues() {
    launchUrl(Uri(scheme: 'https', host: 'github.com', path: 'maelchiotti/LocalMaterialNotes/issues'));
  }

  /// Opens the application's GitHub discussions.
  void openGitHubDiscussions() {
    launchUrl(Uri(scheme: 'https', host: 'github.com', path: 'maelchiotti/LocalMaterialNotes/discussions'));
  }

  /// Sends an email to the contact email with some basic information.
  void sendMail() {
    final systemUtils = SystemUtils();

    final appVersion = systemUtils.appVersion;
    final buildMode = systemUtils.buildMode();
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
  Future<void> copyLogs(BuildContext context) async {
    await logger.copyLogs(context);
  }

  /// Exports the logs to a file.
  Future<void> exportLogs(BuildContext context) async {
    await logger.exportLogs(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopNavigation(appbar: BasicAppBar(title: context.l.navigation_settings_help)),
      body: SingleChildScrollView(
        child: Padding(
          padding: Paddings.bottomSystemUi,
          child: Column(
            children: [
              SettingSection(
                title: SettingSectionTitle(context.l.settings_help_section_contact),
                tiles: [
                  SettingActionTile(
                    icon: SettingTileIcon(Icons.bug_report),
                    title: Text(context.l.settings_github_issues),
                    description: Text(context.l.settings_github_issues_description),
                    onTap: openGitHubIssues,
                  ),
                  SettingActionTile(
                    icon: SettingTileIcon(Icons.forum),
                    title: Text(context.l.settings_github_discussions),
                    description: Text(context.l.settings_github_discussions_description),
                    onTap: openGitHubDiscussions,
                  ),
                  SettingActionTile(
                    icon: SettingTileIcon(Icons.mail),
                    title: Text(context.l.settings_contact_developer),
                    description: Text(context.l.settings_get_in_touch_description(contactEmail)),
                    onTap: sendMail,
                  ),
                ],
              ),
              SettingSection(
                title: SettingSectionTitle(context.l.settings_help_section_logs),
                tiles: [
                  SettingActionTile(
                    icon: SettingTileIcon(Icons.copy_all),
                    title: Text(context.l.settings_copy_logs),
                    description: Text(context.l.settings_copy_logs_description),
                    onTap: () => copyLogs(context),
                  ),
                  SettingActionTile(
                    icon: SettingTileIcon(Symbols.file_save),
                    title: Text(context.l.settings_export_logs),
                    description: Text(context.l.settings_export_logs_description),
                    onTap: () => exportLogs(context),
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
