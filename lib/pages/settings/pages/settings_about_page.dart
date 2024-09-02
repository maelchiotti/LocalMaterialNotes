import 'package:flutter/material.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';
import 'package:localmaterialnotes/common/constants/constants.dart';
import 'package:localmaterialnotes/common/constants/paddings.dart';
import 'package:localmaterialnotes/common/constants/sizes.dart';
import 'package:localmaterialnotes/pages/settings/widgets/custom_settings_list.dart';
import 'package:localmaterialnotes/utils/asset.dart';
import 'package:localmaterialnotes/utils/info_utils.dart';
import 'package:simple_icons/simple_icons.dart';
import 'package:url_launcher/url_launcher.dart';

/// Settings providing information about the application.
class SettingsAboutPage extends StatelessWidget {
  const SettingsAboutPage({super.key});

  static const _contactEmail = 'contact@maelchiotti.dev';

  String? _encodeQueryParameters(Map<String, String> params) {
    return params.entries.map((MapEntry<String, String> e) {
      return '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}';
    }).join('&');
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
        width: Sizes.size64.size,
      ),
      applicationLegalese: localizations.settings_licence_description,
      children: [
        Padding(padding: Paddings.padding16.vertical),
        Text(
          localizations.app_tagline,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        Padding(padding: Paddings.padding8.vertical),
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
        path: _contactEmail,
        query: _encodeQueryParameters({
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

    return CustomSettingsList(
      sections: [
        SettingsSection(
          title: Text(localizations.settings_about_application),
          tiles: [
            SettingsTile(
              leading: const Icon(Icons.info),
              title: Text(localizations.app_name),
              value: Text('v$appVersion'),
              onPressed: _showAbout,
            ),
            SettingsTile(
              leading: const Icon(Icons.build),
              title: Text(localizations.settings_build_mode),
              value: Text(InfoUtils().buildMode),
            ),
          ],
        ),
        SettingsSection(
          title: Text(localizations.settings_about_help),
          tiles: [
            SettingsTile(
              leading: const Icon(Icons.bug_report),
              title: Text(localizations.settings_github_issues),
              value: Text(localizations.settings_github_issues_description),
              onPressed: _openGitHubIssues,
            ),
            SettingsTile(
              leading: const Icon(Icons.forum),
              title: Text(localizations.settings_github_discussions),
              value: Text(localizations.settings_github_discussions_description),
              onPressed: _openGitHubDiscussions,
            ),
            SettingsTile(
              leading: const Icon(Icons.mail),
              title: Text(localizations.settings_get_in_touch),
              value: Text(localizations.settings_get_in_touch_description(_contactEmail)),
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
              value: Text(localizations.settings_github_description),
              onPressed: _openGitHub,
            ),
            SettingsTile(
              leading: const Icon(Icons.balance),
              title: Text(localizations.settings_licence),
              value: Text(localizations.settings_licence_description),
              onPressed: _openLicense,
            ),
          ],
        ),
      ],
    );
  }
}
