import 'package:flutter/material.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';
import 'package:localmaterialnotes/common/constants/constants.dart';
import 'package:localmaterialnotes/common/constants/paddings.dart';
import 'package:localmaterialnotes/common/constants/sizes.dart';
import 'package:localmaterialnotes/common/widgets/navigation/app_bars/basic_app_bar.dart';
import 'package:localmaterialnotes/common/widgets/navigation/top_navigation.dart';
import 'package:localmaterialnotes/pages/settings/widgets/custom_settings_list.dart';
import 'package:localmaterialnotes/utils/asset.dart';
import 'package:localmaterialnotes/utils/info_utils.dart';
import 'package:localmaterialnotes/utils/keys.dart';
import 'package:localmaterialnotes/utils/utils.dart';
import 'package:simple_icons/simple_icons.dart';
import 'package:url_launcher/url_launcher.dart';

/// Settings providing information about the application.
class SettingsAboutPage extends StatelessWidget {
  /// Default constructor.
  const SettingsAboutPage({super.key});

  /// Opens the Crowdin project.
  void _openCrowdin(_) {
    launchUrl(
      Uri(
        scheme: 'https',
        host: 'crowdin.com',
        path: 'project/localmaterialnotes',
      ),
    );
  }

  /// Shows the about dialog.
  Future<void> _showAbout(BuildContext context) async {
    showAboutDialog(
      context: context,
      applicationName: localizations.app_name,
      applicationVersion: InfoUtils().appVersion,
      applicationIcon: Image.asset(
        Asset.icon.path,
        fit: BoxFit.fitWidth,
        width: Sizes.iconSize.size,
      ),
      applicationLegalese: localizations.settings_licence_description,
      children: [
        Padding(padding: Paddings.vertical(16)),
        Text(
          localizations.app_tagline,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        Padding(padding: Paddings.vertical(8)),
        Text(localizations.app_about(localizations.app_name)),
      ],
    );
  }

  /// Opens the application's GitHub issues.
  void _openGitHubIssues(_) {
    launchUrl(
      Uri(
        scheme: 'https',
        host: 'github.com',
        path: 'maelchiotti/LocalMaterialNotes/issues',
      ),
    );
  }

  /// Opens the application's GitHub discussions.
  void _openGitHubDiscussions(_) {
    launchUrl(
      Uri(
        scheme: 'https',
        host: 'github.com',
        path: 'maelchiotti/LocalMaterialNotes/discussions',
      ),
    );
  }

  /// Sends an email to the contact email with some basic information.
  void _sendMail(_) {
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
  void _openGitHub(_) {
    launchUrl(
      Uri(
        scheme: 'https',
        host: 'github.com',
        path: 'maelchiotti/LocalMaterialNotes',
      ),
    );
  }

  /// Opens the application's license file.
  void _openLicense(_) {
    launchUrl(
      Uri(
        scheme: 'https',
        host: 'github.com',
        path: 'maelchiotti/LocalMaterialNotes/blob/main/LICENSE',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appVersion = InfoUtils().appVersion;

    return Scaffold(
      appBar: const TopNavigation(
        key: Keys.appBarSettingsMainSubpage,
        appbar: BasicAppBar.back(),
      ),
      body: CustomSettingsList(
        sections: [
          SettingsSection(
            title: Text(localizations.settings_about_application),
            tiles: [
              SettingsTile(
                leading: const Icon(Icons.info),
                title: Text(localizations.app_name),
                description: Text('v$appVersion'),
                onPressed: _showAbout,
              ),
              SettingsTile(
                leading: const Icon(Icons.build),
                title: Text(localizations.settings_build_mode),
                description: Text(InfoUtils().buildMode),
              ),
            ],
          ),
          SettingsSection(
            title: Text(localizations.settings_about_help),
            tiles: [
              SettingsTile(
                leading: const Icon(Icons.bug_report),
                title: Text(localizations.settings_github_issues),
                description: Text(localizations.settings_github_issues_description),
                onPressed: _openGitHubIssues,
              ),
              SettingsTile(
                leading: const Icon(Icons.forum),
                title: Text(localizations.settings_github_discussions),
                description: Text(localizations.settings_github_discussions_description),
                onPressed: _openGitHubDiscussions,
              ),
              SettingsTile(
                leading: const Icon(Icons.mail),
                title: Text(localizations.settings_get_in_touch),
                description: Text(localizations.settings_get_in_touch_description(contactEmail)),
                onPressed: _sendMail,
              ),
            ],
          ),
          SettingsSection(
            title: Text(localizations.settings_about_links),
            tiles: [
              SettingsTile(
                leading: const Icon(SimpleIcons.github),
                title: Text(localizations.settings_github),
                description: Text(localizations.settings_github_description),
                onPressed: _openGitHub,
              ),
              SettingsTile(
                leading: const Icon(SimpleIcons.crowdin),
                title: Text(localizations.settings_localizations),
                description: Text(localizations.settings_localizations_description),
                onPressed: _openCrowdin,
              ),
              SettingsTile(
                leading: const Icon(Icons.balance),
                title: Text(localizations.settings_licence),
                description: Text(localizations.settings_licence_description),
                onPressed: _openLicense,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
