import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';
import 'package:locale_names/locale_names.dart';
import 'package:localmaterialnotes/pages/settings/settings_actions.dart';
import 'package:localmaterialnotes/providers/notes/notes_provider.dart';
import 'package:localmaterialnotes/utils/auto_export_utils.dart';
import 'package:localmaterialnotes/utils/constants/constants.dart';
import 'package:localmaterialnotes/utils/constants/paddings.dart';
import 'package:localmaterialnotes/utils/extensions/string_extension.dart';
import 'package:localmaterialnotes/utils/extensions/uri_extension.dart';
import 'package:localmaterialnotes/utils/info_utils.dart';
import 'package:localmaterialnotes/utils/preferences/confirmations.dart';
import 'package:localmaterialnotes/utils/preferences/preference_key.dart';
import 'package:localmaterialnotes/utils/theme_utils.dart';
import 'package:simple_icons/simple_icons.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage();

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  final interactions = SettingsActions();

  bool showUndoRedoButtons = PreferenceKey.showUndoRedoButtons.getPreferenceOrDefault<bool>();
  bool showChecklistButton = PreferenceKey.showChecklistButton.getPreferenceOrDefault<bool>();
  bool showToolbar = PreferenceKey.showToolbar.getPreferenceOrDefault<bool>();

  bool flagSecure = PreferenceKey.flagSecure.getPreferenceOrDefault<bool>();
  bool showSeparators = PreferenceKey.showSeparators.getPreferenceOrDefault<bool>();
  bool showTilesBackground = PreferenceKey.showTilesBackground.getPreferenceOrDefault<bool>();

  @override
  Widget build(BuildContext context) {
    return SettingsList(
      platform: DevicePlatform.android,
      contentPadding: Paddings.custom.bottomSystemUi,
      lightTheme: SettingsThemeData(
        settingsListBackground: Theme.of(context).colorScheme.surface,
      ),
      darkTheme: SettingsThemeData(
        settingsListBackground: Theme.of(context).colorScheme.surface,
      ),
      sections: [
        SettingsSection(
          title: Text(localizations.settings_appearance),
          tiles: [
            SettingsTile.navigation(
              leading: const Icon(Icons.language),
              title: Text(localizations.settings_language),
              value: Text(Localizations.localeOf(context).nativeDisplayLanguage.capitalized),
              onPressed: interactions.selectLanguage,
            ),
            SettingsTile.navigation(
              leading: const Icon(Icons.palette),
              title: Text(localizations.settings_theme),
              value: Text(ThemeUtils().themeModeName),
              onPressed: (context) async {
                await interactions.selectTheme(context);
                setState(() {});
              },
            ),
            SettingsTile.switchTile(
              enabled: ThemeUtils().isDynamicThemingAvailable,
              leading: const Icon(Icons.bolt),
              title: Text(localizations.settings_dynamic_theming),
              description: Text(localizations.settings_dynamic_theming_description),
              initialValue: ThemeUtils().useDynamicTheming,
              onToggle: interactions.toggleDynamicTheming,
            ),
            SettingsTile.switchTile(
              enabled: ThemeUtils().brightness == Brightness.dark,
              leading: const Icon(Icons.nightlight),
              title: Text(localizations.settings_black_theming),
              description: Text(localizations.settings_black_theming_description),
              initialValue: ThemeUtils().useBlackTheming,
              onToggle: (toggled) {
                interactions.toggleBlackTheming(toggled);
                setState(() {});
              },
            ),
          ],
        ),
        SettingsSection(
          title: Text(localizations.settings_editor),
          tiles: [
            SettingsTile.switchTile(
              leading: const Icon(Icons.undo),
              title: Text(localizations.settings_show_undo_redo_buttons),
              description: Text(localizations.settings_show_undo_redo_buttons_description),
              initialValue: showUndoRedoButtons,
              onToggle: (toggled) {
                interactions.toggleBooleanSetting(PreferenceKey.showUndoRedoButtons, toggled);
                setState(() {
                  showUndoRedoButtons = toggled;
                });
              },
            ),
            SettingsTile.switchTile(
              leading: const Icon(Icons.checklist),
              title: Text(localizations.settings_show_checklist_button),
              description: Text(localizations.settings_show_checklist_button_description),
              initialValue: showChecklistButton,
              onToggle: (toggled) {
                interactions.toggleBooleanSetting(PreferenceKey.showChecklistButton, toggled);
                setState(() {
                  showChecklistButton = toggled;
                });
              },
            ),
            SettingsTile.switchTile(
              leading: const Icon(Icons.format_paint),
              title: Text(localizations.settings_show_toolbar),
              description: Text(localizations.settings_show_toolbar_description),
              initialValue: showToolbar,
              onToggle: (toggled) {
                interactions.toggleBooleanSetting(PreferenceKey.showToolbar, toggled);
                setState(() {
                  showToolbar = toggled;
                });
              },
            ),
          ],
        ),
        SettingsSection(
          title: Text(localizations.settings_behavior),
          tiles: [
            SettingsTile.navigation(
              leading: const Icon(Icons.warning),
              title: Text(localizations.settings_confirmations),
              value: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    Confirmations.fromPreference().title,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  Text(localizations.settings_confirmations_description),
                ],
              ),
              onPressed: (context) async {
                await interactions.selectConfirmations(context);
                setState(() {});
              },
            ),
            SettingsTile.switchTile(
              leading: const Icon(Icons.security),
              title: Text(localizations.settings_flag_secure),
              description: Text(localizations.settings_flag_secure_description),
              initialValue: flagSecure,
              onToggle: (toggled) async {
                await interactions.setFlagSecure(toggled);
                setState(() {
                  flagSecure = toggled;
                });
              },
            ),
            SettingsTile.switchTile(
              leading: const Icon(Icons.safety_divider),
              title: Text(localizations.settings_show_separators),
              description: Text(localizations.settings_show_separators_description),
              initialValue: showSeparators,
              onToggle: (toggled) {
                interactions.toggleBooleanSetting(PreferenceKey.showSeparators, toggled);
                setState(() {
                  showSeparators = toggled;
                });
                ref.invalidate(notesProvider); // Refresh the notes and bin pages
              },
            ),
            SettingsTile.switchTile(
              leading: const Icon(Icons.gradient),
              title: Text(localizations.settings_show_tiles_background),
              description: Text(localizations.settings_show_tiles_background_description),
              initialValue: showTilesBackground,
              onToggle: (toggled) {
                interactions.toggleBooleanSetting(PreferenceKey.showTilesBackground, toggled);
                setState(() {
                  showTilesBackground = toggled;
                });
                ref.invalidate(notesProvider); // Refresh the notes and bin pages
              },
            ),
          ],
        ),
        SettingsSection(
          title: Text(localizations.settings_backup),
          tiles: [
            SettingsTile.navigation(
              leading: const Icon(Icons.settings_backup_restore),
              title: Text(localizations.settings_auto_export),
              value: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    PreferenceKey.autoExportFrequency.getPreferenceOrDefault<double>() == 0
                        ? localizations.settings_auto_export_disabled
                        : localizations.settings_auto_export_value(
                            PreferenceKey.autoExportEncryption.getPreferenceOrDefault<bool>().toString(),
                            PreferenceKey.autoExportFrequency.getPreferenceOrDefault<double>().toInt().toString(),
                          ),
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  Text(localizations.settings_auto_export_description),
                  Text(
                    localizations.settings_auto_export_directory(AutoExportUtils().backupsDirectory.toDecodedString),
                  ),
                ],
              ),
              onPressed: (context) async {
                await interactions.autoExportAsJson(context);
                setState(() {});
              },
            ),
            SettingsTile.navigation(
              leading: const Icon(SimpleIcons.json),
              title: Text(localizations.settings_export_json),
              value: Text(localizations.settings_export_json_description),
              onPressed: interactions.exportAsJson,
            ),
            SettingsTile.navigation(
              leading: const Icon(SimpleIcons.markdown),
              title: Text(localizations.settings_export_markdown),
              value: Text(localizations.settings_export_markdown_description),
              onPressed: interactions.exportAsMarkdown,
            ),
            SettingsTile.navigation(
              leading: const Icon(Icons.file_upload),
              title: Text(localizations.settings_import),
              value: Text(localizations.settings_import_description),
              onPressed: (context) => interactions.import(context, ref),
            ),
          ],
        ),
        SettingsSection(
          title: Text(localizations.settings_about),
          tiles: [
            SettingsTile(
              leading: const Icon(Icons.info),
              title: Text(localizations.app_name),
              value: Text(InfoUtils().appVersion),
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
