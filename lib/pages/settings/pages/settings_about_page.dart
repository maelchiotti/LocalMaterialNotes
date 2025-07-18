import 'package:flutter/material.dart';
import 'package:settings_tiles/settings_tiles.dart';
import 'package:simple_icons/simple_icons.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../common/constants/paddings.dart';
import '../../../common/constants/sizes.dart';
import '../../../common/extensions/build_context_extension.dart';
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
      appBar: TopNavigation(appbar: BasicAppBar(title: context.l.navigation_settings_about)),
      body: SingleChildScrollView(
        child: Padding(
          padding: Paddings.bottomSystemUi,
          child: Column(
            children: [
              SettingSection(
                title: SettingSectionTitle(context.l.settings_about_application),
                tiles: [
                  SettingAboutTile(
                    applicationName: context.l.app_name,
                    applicationVersion: 'v$appVersion ($appBuildNumber)',
                    applicationIcon: Image.asset(Asset.icon.path, fit: BoxFit.fitWidth, width: Sizes.appIcon.size),
                    applicationLegalese: context.l.settings_licence_description,
                    dialogChildren: [
                      Padding(padding: Paddings.vertical(16)),
                      Text(context.l.app_tagline, style: Theme.of(context).textTheme.titleSmall),
                      Padding(padding: Paddings.vertical(8)),
                      Text(context.l.app_about(context.l.app_name)),
                    ],
                  ),
                  SettingTextTile(
                    icon: SettingTileIcon(Icons.build),
                    title: Text(context.l.settings_build_mode),
                    description: Text(SystemUtils().buildMode(context)),
                  ),
                ],
              ),
              SettingSection(
                title: SettingSectionTitle(context.l.settings_about_links),
                tiles: [
                  SettingActionTile(
                    icon: SettingTileIcon(SimpleIcons.github),
                    title: Text(context.l.settings_github),
                    description: Text(context.l.settings_github_description),
                    onTap: openGitHub,
                  ),
                  SettingActionTile(
                    icon: SettingTileIcon(SimpleIcons.crowdin),
                    title: Text(context.l.settings_localizations),
                    description: Text(context.l.settings_localizations_description),
                    onTap: openCrowdin,
                  ),
                  SettingActionTile(
                    icon: SettingTileIcon(Icons.balance),
                    title: Text(context.l.settings_licence),
                    description: Text(context.l.settings_licence_description),
                    onTap: openLicense,
                  ),
                ],
              ),
              SettingSection(
                title: SettingSectionTitle(context.l.settings_about_section_donate),
                tiles: [
                  SettingActionTile(
                    icon: SettingTileIcon(SimpleIcons.kofi),
                    title: Text(context.l.settings_donate_kofi),
                    onTap: donateKoFi,
                  ),
                  SettingActionTile(
                    icon: SettingTileIcon(SimpleIcons.paypal),
                    title: Text(context.l.settings_donate_paypal),
                    onTap: donatePayPal,
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
