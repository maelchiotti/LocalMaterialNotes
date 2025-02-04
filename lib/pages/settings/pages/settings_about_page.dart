import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:settings_tiles/settings_tiles.dart';
import 'package:simple_icons/simple_icons.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../common/constants/constants.dart';
import '../../../common/constants/paddings.dart';
import '../../../common/constants/sizes.dart';
import '../../../common/navigation/app_bars/basic_app_bar.dart';
import '../../../common/navigation/top_navigation.dart';
import '../../../common/system/info_utils.dart';
import '../../../common/utils.dart';
import '../../../common/widgets/asset.dart';

/// Settings providing information about the application.
class SettingsAboutPage extends StatelessWidget {
  /// Default constructor.
  const SettingsAboutPage({super.key});

  /// Opens the Crowdin project.
  void _openCrowdin() {
    launchUrl(
      Uri(
        scheme: 'https',
        host: 'crowdin.com',
        path: 'project/localmaterialnotes',
      ),
    );
  }

  /// Opens the application's GitHub issues.
  void _openGitHubIssues() {
    launchUrl(
      Uri(
        scheme: 'https',
        host: 'github.com',
        path: 'maelchiotti/LocalMaterialNotes/issues',
      ),
    );
  }

  /// Opens the application's GitHub discussions.
  void _openGitHubDiscussions() {
    launchUrl(
      Uri(
        scheme: 'https',
        host: 'github.com',
        path: 'maelchiotti/LocalMaterialNotes/discussions',
      ),
    );
  }

  /// Sends an email to the contact email with some basic information.
  void _sendMail() {
    final appVersion = InfoUtils().appVersion;
    final buildMode = InfoUtils().buildMode;
    final androidVersion = InfoUtils().androidVersion;
    final brand = InfoUtils().brand;
    final model = InfoUtils().model;

    launchUrl(
      Uri(
        scheme: 'mailto',
        path: contactEmail,
        query: encodeQueryParameters({
          'subject': '[Material Notes] ',
          'body': '\n\n\n----------\nv$appVersion\n$buildMode mode\nAndroid $androidVersion\n$brand $model',
        }),
      ),
    );
  }

  /// Opens the application's GitHub repository.
  void _openGitHub() {
    launchUrl(
      Uri(
        scheme: 'https',
        host: 'github.com',
        path: 'maelchiotti/LocalMaterialNotes',
      ),
    );
  }

  /// Opens the application's license file.
  void _openLicense() {
    launchUrl(
      Uri(
        scheme: 'https',
        host: 'github.com',
        path: 'maelchiotti/LocalMaterialNotes/blob/main/LICENSE',
      ),
    );
  }

  Future<void> _copyLogs() async {
    await logger.copyLogs();
  }

  Future<void> _exportLogs() async {
    await logger.exportLogs();
  }

  @override
  Widget build(BuildContext context) {
    final appVersion = InfoUtils().appVersion;
    final appBuildNumber = InfoUtils().buildNumber;

    return Scaffold(
      appBar: TopNavigation(
        appbar: BasicAppBar(title: l.navigation_settings_about),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: Paddings.bottomSystemUi,
          child: Column(
            children: [
              SettingSection(
                divider: null,
                title: l.settings_about_application,
                tiles: [
                  SettingAboutTile(
                    title: l.app_name,
                    description: 'v$appVersion ($appBuildNumber)',
                    applicationIcon: Image.asset(
                      Asset.icon.path,
                      fit: BoxFit.fitWidth,
                      width: Sizes.iconSize.size,
                    ),
                    applicationLegalese: l.settings_licence_description,
                    dialogChildren: [
                      Padding(padding: Paddings.vertical(16)),
                      Text(
                        l.app_tagline,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      Padding(padding: Paddings.vertical(8)),
                      Text(l.app_about(l.app_name)),
                    ],
                  ),
                  SettingTextTile(
                    icon: Icons.build,
                    title: l.settings_build_mode,
                    description: InfoUtils().buildMode,
                  ),
                ],
              ),
              SettingSection(
                divider: null,
                title: l.settings_about_help,
                tiles: [
                  SettingActionTile(
                    icon: Icons.bug_report,
                    title: l.settings_github_issues,
                    description: l.settings_github_issues_description,
                    onTap: _openGitHubIssues,
                  ),
                  SettingActionTile(
                    icon: Icons.forum,
                    title: l.settings_github_discussions,
                    description: l.settings_github_discussions_description,
                    onTap: _openGitHubDiscussions,
                  ),
                  SettingActionTile(
                    icon: Icons.mail,
                    title: l.settings_get_in_touch,
                    description: l.settings_get_in_touch_description(contactEmail),
                    onTap: _sendMail,
                  ),
                ],
              ),
              SettingSection(
                divider: null,
                title: l.settings_about_links,
                tiles: [
                  SettingActionTile(
                    icon: SimpleIcons.github,
                    title: l.settings_github,
                    description: l.settings_github_description,
                    onTap: _openGitHub,
                  ),
                  SettingActionTile(
                    icon: SimpleIcons.crowdin,
                    title: l.settings_localizations,
                    description: l.settings_localizations_description,
                    onTap: _openCrowdin,
                  ),
                  SettingActionTile(
                    icon: Icons.balance,
                    title: l.settings_licence,
                    description: l.settings_licence_description,
                    onTap: _openLicense,
                  ),
                ],
              ),
              SettingSection(
                divider: null,
                title: l.settings_about_logs,
                tiles: [
                  SettingActionTile(
                    icon: Icons.copy_all,
                    title: l.settings_copy_logs,
                    description: l.settings_copy_logs_description,
                    onTap: _copyLogs,
                  ),
                  SettingActionTile(
                    icon: Symbols.file_save,
                    title: l.settings_export_logs,
                    description: l.settings_export_logs_description,
                    onTap: _exportLogs,
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
