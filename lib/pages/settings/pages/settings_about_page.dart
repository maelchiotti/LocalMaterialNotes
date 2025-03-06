import 'package:flutter/material.dart';
import 'package:settings_tiles/settings_tiles.dart';
import 'package:simple_icons/simple_icons.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../common/constants/constants.dart';
import '../../../common/constants/paddings.dart';
import '../../../common/constants/sizes.dart';
import '../../../common/navigation/app_bars/basic_app_bar.dart';
import '../../../common/navigation/top_navigation.dart';
import '../../../common/system_utils.dart';
import '../../../common/widgets/asset.dart';

/// Settings providing information about the application.
class SettingsAboutPage extends StatelessWidget {
  /// Default constructor.
  const SettingsAboutPage({super.key});

  /// Opens the Crowdin project.
  void openCrowdin() {
    launchUrl(Uri(scheme: 'https', host: 'crowdin.com', path: 'project/localmaterialnotes'));
  }

  /// Opens the application's GitHub repository.
  void openGitHub() {
    launchUrl(Uri(scheme: 'https', host: 'github.com', path: 'maelchiotti/LocalMaterialNotes'));
  }

  /// Opens the application's license file.
  void openLicense() {
    launchUrl(Uri(scheme: 'https', host: 'github.com', path: 'maelchiotti/LocalMaterialNotes/blob/main/LICENSE'));
  }

  /// Opens the PayPal donation page.
  Future<void> donatePayPal() async {
    await launchUrl(Uri(scheme: 'https', host: 'paypal.me', path: 'maelchiotti'));
  }

  /// Opens the Ko-fi donation page.
  Future<void> donateKoFi() async {
    await launchUrl(Uri(scheme: 'https', host: 'ko-fi.com', path: 'maelchiotti'));
  }

  @override
  Widget build(BuildContext context) {
    final appVersion = SystemUtils().appVersion;
    final appBuildNumber = SystemUtils().buildNumber;

    return Scaffold(
      appBar: TopNavigation(appbar: BasicAppBar(title: l.navigation_settings_about)),
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
                    applicationIcon: Image.asset(Asset.icon.path, fit: BoxFit.fitWidth, width: Sizes.appIcon.size),
                    applicationLegalese: l.settings_licence_description,
                    dialogChildren: [
                      Padding(padding: Paddings.vertical(16)),
                      Text(l.app_tagline, style: Theme.of(context).textTheme.titleSmall),
                      Padding(padding: Paddings.vertical(8)),
                      Text(l.app_about(l.app_name)),
                    ],
                  ),
                  SettingTextTile(
                    icon: Icons.build,
                    title: l.settings_build_mode,
                    description: SystemUtils().buildMode,
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
                    onTap: openGitHub,
                  ),
                  SettingActionTile(
                    icon: SimpleIcons.crowdin,
                    title: l.settings_localizations,
                    description: l.settings_localizations_description,
                    onTap: openCrowdin,
                  ),
                  SettingActionTile(
                    icon: Icons.balance,
                    title: l.settings_licence,
                    description: l.settings_licence_description,
                    onTap: openLicense,
                  ),
                ],
              ),
              SettingSection(
                divider: null,
                title: l.settings_about_section_donate,
                tiles: [
                  SettingActionTile(icon: SimpleIcons.kofi, title: l.settings_donate_kofi, onTap: donateKoFi),
                  SettingActionTile(icon: SimpleIcons.paypal, title: l.settings_donate_paypal, onTap: donatePayPal),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
