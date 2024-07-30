import 'package:flutter/material.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';
import 'package:localmaterialnotes/pages/settings/widgets/custom_settings_list.dart';
import 'package:localmaterialnotes/utils/asset.dart';
import 'package:localmaterialnotes/utils/constants/constants.dart';
import 'package:localmaterialnotes/utils/constants/paddings.dart';
import 'package:localmaterialnotes/utils/constants/sizes.dart';
import 'package:localmaterialnotes/utils/info_utils.dart';
import 'package:simple_icons/simple_icons.dart';
import 'package:url_launcher/url_launcher.dart';

/// Settings providing information about the application.
class SettingsAboutPage extends StatelessWidget {
  const SettingsAboutPage({super.key});

  String? _encodeQueryParameters(Map<String, String> params) {
    return params.entries.map((MapEntry<String, String> e) {
      return '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}';
    }).join('&');
  }

  /// Shows the about dialog.
  Future<void> _showAbout(BuildContext context) async {
    showAboutDialog(
      context: context,
      useRootNavigator: false,
      applicationName: localizations.app_name,
      applicationVersion: InfoUtils().appVersion,
      applicationIcon: Image.asset(
        Asset.icon.path,
        filterQuality: FilterQuality.medium,
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

  /// Opens the application's GitHub issues.
  void _openIssues(_) {
    launchUrl(
      Uri(
        scheme: 'https',
        host: 'github.com',
        path: 'maelchiotti/LocalMaterialNotes/issues',
      ),
    );
  }

  /// Sends an email to `contact@maelchiotti.dev` with some basic information.
  void _sendMail(_) {
    final appVersion = InfoUtils().appVersion;
    final buildMode = InfoUtils().buildMode;
    final androidVersion = InfoUtils().androidVersion;

    launchUrl(
      Uri(
        scheme: 'mailto',
        path: 'contact@maelchiotti.dev',
        query: _encodeQueryParameters({
          'subject': '[Material Notes] ',
          'body': '\n\n\n----------\nv$appVersion\n$buildMode mode\nAndroid $androidVersion',
        }),
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
              value: Text(appVersion),
              onPressed: _showAbout,
            ),
            SettingsTile(
              leading: const Icon(Icons.build),
              title: Text(localizations.settings_build_mode),
              value: Text(InfoUtils().buildMode),
              onPressed: _showAbout,
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
            SettingsTile(
              leading: const Icon(Icons.bug_report),
              title: Text(localizations.settings_issue),
              value: Text(localizations.settings_issue_description),
              onPressed: _openIssues,
            ),
            SettingsTile(
              leading: const Icon(Icons.mail),
              title: Text(localizations.settings_get_in_touch),
              value: Text(localizations.settings_get_in_touch_description),
              onPressed: _sendMail,
            ),
          ],
        ),
      ],
    );
  }
}
