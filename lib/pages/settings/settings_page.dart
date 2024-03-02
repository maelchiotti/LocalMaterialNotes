import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';
import 'package:locale_names/locale_names.dart';
import 'package:localmaterialnotes/pages/settings/interactions.dart';
import 'package:localmaterialnotes/utils/constants/constants.dart';
import 'package:localmaterialnotes/utils/constants/paddings.dart';
import 'package:localmaterialnotes/utils/extensions/string_extension.dart';
import 'package:localmaterialnotes/utils/info_manager.dart';
import 'package:localmaterialnotes/utils/preferences/confirmations.dart';
import 'package:localmaterialnotes/utils/preferences/preference_key.dart';
import 'package:localmaterialnotes/utils/preferences/preferences_manager.dart';
import 'package:localmaterialnotes/utils/theme_manager.dart';
import 'package:simple_icons/simple_icons.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage();

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  final interactions = Interactions();

  bool useSeparators =
      PreferencesManager().get<bool>(PreferenceKey.separator) ?? PreferenceKey.separator.defaultValue! as bool;

  @override
  Widget build(BuildContext context) {
    return SettingsList(
      platform: DevicePlatform.android,
      contentPadding: Paddings.custom.bottomSystemUi,
      lightTheme: SettingsThemeData(
        settingsListBackground: Theme.of(context).colorScheme.background,
      ),
      darkTheme: SettingsThemeData(
        settingsListBackground: Theme.of(context).colorScheme.background,
      ),
      sections: [
        SettingsSection(
          title: Text(localizations.settings_appearance),
          tiles: [
            SettingsTile.navigation(
              leading: const Icon(Icons.palette),
              title: Text(localizations.settings_theme),
              value: Text(ThemeManager().themeModeName),
              onPressed: (context) async {
                await interactions.selectTheme(context);
                setState(() {});
              },
            ),
            SettingsTile.switchTile(
              enabled: ThemeManager().isDynamicThemingAvailable,
              leading: const Icon(Icons.bolt),
              title: Text(localizations.settings_dynamic_theming),
              description: Text(localizations.settings_dynamic_theming_description),
              initialValue: ThemeManager().useDynamicTheming,
              onToggle: interactions.toggleDynamicTheming,
            ),
            SettingsTile.switchTile(
              enabled: ThemeManager().brightness == Brightness.dark,
              leading: const Icon(Icons.nightlight),
              title: Text(localizations.settings_black_theming),
              description: Text(localizations.settings_black_theming_description),
              initialValue: ThemeManager().useBlackTheming,
              onToggle: (toggled) {
                interactions.toggleBlackTheming(toggled);
                setState(() {});
              },
            ),
            SettingsTile.navigation(
              leading: const Icon(Icons.language),
              title: Text(localizations.settings_language),
              value: Text(Localizations.localeOf(context).nativeDisplayLanguage.capitalized),
              onPressed: interactions.selectLanguage,
            ),
          ],
        ),
        SettingsSection(
          title: Text(localizations.settings_behavior),
          tiles: [
            SettingsTile.navigation(
              leading: const Icon(Icons.warning),
              title: Text(localizations.settings_confirmations),
              value: Text(Confirmations.fromPreferences().title),
              onPressed: (context) async {
                await interactions.selectConfirmations(context);
                setState(() {});
              },
            ),
            SettingsTile.switchTile(
              leading: const Icon(Icons.safety_divider),
              title: Text(localizations.settings_separator),
              description: Text(localizations.settings_separator_description),
              initialValue: useSeparators,
              onToggle: (toggled) {
                interactions.toggleSeparator(toggled);
                setState(() {
                  useSeparators = toggled;
                });
              },
            ),
          ],
        ),
        SettingsSection(
          title: Text(localizations.settings_backup),
          tiles: [
            SettingsTile.navigation(
              leading: const Icon(SimpleIcons.json),
              title: Text(localizations.settings_export_json),
              value: Text(localizations.settings_export_json_description),
              onPressed: interactions.backupAsJson,
            ),
            SettingsTile.navigation(
              leading: const Icon(SimpleIcons.markdown),
              title: Text(localizations.settings_export_markdown),
              value: Text(localizations.settings_export_markdown_description),
              onPressed: interactions.backupAsMarkdown,
            ),
            SettingsTile.navigation(
              leading: const Icon(Icons.file_upload),
              title: Text(localizations.settings_import),
              value: Text(localizations.settings_import_description),
              onPressed: interactions.restore,
            ),
          ],
        ),
        SettingsSection(
          title: Text(localizations.settings_about),
          tiles: [
            SettingsTile(
              leading: const Icon(Icons.info),
              title: Text(localizations.app_name),
              value: Text(InfoManager().appVersion),
              onPressed: interactions.showAbout,
            ),
            SettingsTile(
              leading: const Icon(SimpleIcons.github),
              title: Text(localizations.settings_github),
              value: Text(localizations.settings_github_description),
              onPressed: interactions.openGitHub,
            ),
            SettingsTile(
              leading: const Icon(Icons.balance),
              title: Text(localizations.settings_licence),
              value: Text(localizations.settings_licence_description),
              onPressed: interactions.openLicense,
            ),
            SettingsTile(
              leading: const Icon(Icons.bug_report),
              title: Text(localizations.settings_issue),
              value: Text(localizations.settings_issue_description),
              onPressed: interactions.openIssues,
            ),
          ],
        ),
      ],
    );
  }
}
