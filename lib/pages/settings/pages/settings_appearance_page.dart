import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:locale_names/locale_names.dart';
import 'package:localmaterialnotes/common/constants/constants.dart';
import 'package:localmaterialnotes/common/enums/localization_completion.dart';
import 'package:localmaterialnotes/common/extensions/double_extension.dart';
import 'package:localmaterialnotes/common/extensions/string_extension.dart';
import 'package:localmaterialnotes/common/navigation/app_bars/basic_app_bar.dart';
import 'package:localmaterialnotes/common/navigation/top_navigation.dart';
import 'package:localmaterialnotes/common/preferences/preference_key.dart';
import 'package:localmaterialnotes/common/preferences/preferences_utils.dart';
import 'package:localmaterialnotes/l10n/app_localizations/app_localizations.g.dart';
import 'package:localmaterialnotes/pages/settings/dialogs/text_scaling_dialog.dart';
import 'package:localmaterialnotes/providers/notifiers.dart';
import 'package:localmaterialnotes/utils/keys.dart';
import 'package:localmaterialnotes/utils/locale_utils.dart';
import 'package:localmaterialnotes/utils/theme_utils.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:restart_app/restart_app.dart';
import 'package:settings_tiles/settings_tiles.dart';
import 'package:url_launcher/url_launcher.dart';

/// Settings related to the appearance of the application.
class SettingsAppearancePage extends StatefulWidget {
  /// Default constructor.
  const SettingsAppearancePage({super.key});

  @override
  State<SettingsAppearancePage> createState() => _SettingsAppearancePageState();
}

class _SettingsAppearancePageState extends State<SettingsAppearancePage> {
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

  /// Asks the user to select the language of the application.
  ///
  /// Restarts the application if the language is changed.
  Future<void> _selectLanguage() async {
    await showAdaptiveDialog<Locale>(
      context: context,
      useRootNavigator: false,
      builder: (context) {
        return SimpleDialog(
          clipBehavior: Clip.hardEdge,
          title: Text(l.settings_language),
          children: AppLocalizations.supportedLocales.map((locale) {
            return RadioListTile<Locale>(
              value: locale,
              groupValue: Localizations.localeOf(context),
              title: Text(locale.nativeDisplayLanguage.capitalized),
              subtitle: Text(LocalizationCompletion.getFormattedPercentage(locale)),
              selected: Localizations.localeOf(context) == locale,
              onChanged: (locale) => Navigator.pop(context, locale),
            );
          }).toList(),
        );
      },
    ).then((locale) async {
      if (locale == null) {
        return;
      }

      await LocaleUtils().setLocale(locale);

      // The Restart package crashes the app if used in debug mode.
      if (kDebugMode) {
        return;
      }

      await Restart.restartApp();
    });
  }

  /// Asks the user to select the theme of the application.
  Future<void> _selectTheme() async {
    await showAdaptiveDialog<ThemeMode>(
      context: context,
      useRootNavigator: false,
      builder: (context) {
        return SimpleDialog(
          clipBehavior: Clip.hardEdge,
          title: Text(l.settings_theme),
          children: [
            RadioListTile<ThemeMode>(
              value: ThemeMode.system,
              groupValue: ThemeUtils().themeMode,
              title: Text(l.settings_theme_system),
              selected: ThemeUtils().themeMode == ThemeMode.system,
              onChanged: (themeMode) => Navigator.pop(context, themeMode),
            ),
            RadioListTile<ThemeMode>(
              value: ThemeMode.light,
              groupValue: ThemeUtils().themeMode,
              title: Text(l.settings_theme_light),
              selected: ThemeUtils().themeMode == ThemeMode.light,
              onChanged: (themeMode) => Navigator.pop(context, themeMode),
            ),
            RadioListTile<ThemeMode>(
              value: ThemeMode.dark,
              groupValue: ThemeUtils().themeMode,
              title: Text(l.settings_theme_dark),
              selected: ThemeUtils().themeMode == ThemeMode.dark,
              onChanged: (themeMode) => Navigator.pop(context, themeMode),
            ),
          ],
        );
      },
    ).then((themeMode) {
      if (themeMode == null) {
        return;
      }

      ThemeUtils().setThemeMode(themeMode);
    });
  }

  /// Toggles the dynamic theming.
  void _toggleDynamicTheming(bool toggled) {
    setState(() {
      PreferencesUtils().set<bool>(PreferenceKey.dynamicTheming, toggled);
    });

    dynamicThemingNotifier.value = toggled;
  }

  /// Toggles the black theming.
  void _toggleBlackTheming(bool toggled) {
    setState(() {
      PreferencesUtils().set<bool>(PreferenceKey.blackTheming, toggled);
    });

    blackThemingNotifier.value = toggled;
  }

  Future<void> _setTextScaling() async {
    await showAdaptiveDialog<double>(
      context: context,
      useRootNavigator: false,
      builder: (context) => const TextScalingDialog(),
    ).then((textScaling) async {
      if (textScaling == null) {
        // Set the text scaling back to its preference value
        textScalingNotifier.value = PreferenceKey.textScaling.getPreferenceOrDefault<double>();

        return;
      }

      setState(() {
        PreferencesUtils().set<double>(PreferenceKey.textScaling, textScaling);
      });

      textScalingNotifier.value = textScaling;
    });
  }

  /// Toggles the setting to show background of the notes tiles.
  void _toggleShowTitlesOnly(bool toggled) {
    setState(() {
      PreferencesUtils().set<bool>(PreferenceKey.showTitlesOnly, toggled);
    });

    showTitlesOnlyNotifier.value = toggled;
  }

  /// Toggles the setting to show background of the notes tiles.
  void _toggleShowTitlesOnlyDisableInSearchView(bool toggled) {
    setState(() {
      PreferencesUtils().set<bool>(PreferenceKey.showTitlesOnlyDisableInSearchView, toggled);
    });
  }

  /// Toggles the setting to show background of the notes tiles.
  void _toggleDisableSubduedNoteContentPreview(bool toggled) {
    setState(() {
      PreferencesUtils().set<bool>(PreferenceKey.disableSubduedNoteContentPreview, toggled);
    });
  }

  /// Toggles the setting to show background of the notes tiles.
  void _toggleShowTilesBackground(bool toggled) {
    setState(() {
      PreferencesUtils().set<bool>(PreferenceKey.showTilesBackground, toggled);
    });

    showTilesBackgroundNotifier.value = toggled;
  }

  /// Toggles the setting to show the separators between the notes tiles.
  void _toggleShowSeparators(bool toggled) {
    setState(() {
      PreferencesUtils().set<bool>(PreferenceKey.showSeparators, toggled);
    });

    showSeparatorsNotifier.value = toggled;
  }

  @override
  Widget build(BuildContext context) {
    final locale = LocaleUtils().appLocale.nativeDisplayLanguage.capitalized;
    final showUseBlackTheming = Theme.of(context).colorScheme.brightness == Brightness.dark;
    final textScaling = PreferenceKey.textScaling.getPreferenceOrDefault<double>();

    final showTitlesOnly = PreferenceKey.showTitlesOnly.getPreferenceOrDefault<bool>();
    final showTitlesOnlyDisableInSearchView =
        PreferenceKey.showTitlesOnlyDisableInSearchView.getPreferenceOrDefault<bool>();
    final disableSubduedNoteContentPreview =
        PreferenceKey.disableSubduedNoteContentPreview.getPreferenceOrDefault<bool>();
    final showTilesBackground = PreferenceKey.showTilesBackground.getPreferenceOrDefault<bool>();
    final showSeparators = PreferenceKey.showSeparators.getPreferenceOrDefault<bool>();

    return Scaffold(
      appBar: const TopNavigation(
        key: Keys.appBarSettingsMainSubpage,
        appbar: BasicAppBar.back(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SettingSection(
              divider: null,
              title: l.settings_appearance_application,
              tiles: [
                SettingActionTile(
                  icon: Icons.language,
                  title: l.settings_language,
                  trailing: TextButton.icon(
                    onPressed: _openCrowdin,
                    label: Text(l.settings_language_contribute),
                  ),
                  value: locale,
                  onTap: _selectLanguage,
                ),
                SettingActionTile(
                  icon: Icons.palette,
                  title: l.settings_theme,
                  value: ThemeUtils().themeModeTitle,
                  onTap: _selectTheme,
                ),
                SettingSwitchTile(
                  enabled: ThemeUtils().isDynamicThemingAvailable,
                  icon: Icons.bolt,
                  title: l.settings_dynamic_theming,
                  description: l.settings_dynamic_theming_description,
                  toggled: ThemeUtils().useDynamicTheming,
                  onChanged: _toggleDynamicTheming,
                ),
                SettingSwitchTile(
                  enabled: showUseBlackTheming,
                  icon: Icons.nightlight,
                  title: l.settings_black_theming,
                  description: l.settings_black_theming_description,
                  toggled: ThemeUtils().useBlackTheming,
                  onChanged: _toggleBlackTheming,
                ),
                SettingActionTile(
                  icon: Icons.format_size,
                  title: l.settings_text_scaling,
                  value: textScaling.formatedAsPercentage(locale: LocaleUtils().appLocale),
                  onTap: _setTextScaling,
                ),
              ],
            ),
            SettingSection(
              divider: null,
              title: l.settings_appearance_notes_tiles,
              tiles: [
                SettingSwitchTile(
                  icon: Icons.view_compact,
                  title: l.settings_show_titles_only,
                  description: l.settings_show_titles_only_description,
                  toggled: showTitlesOnly,
                  onChanged: _toggleShowTitlesOnly,
                ),
                SettingSwitchTile(
                  enabled: showTitlesOnly,
                  icon: Symbols.feature_search,
                  title: l.settings_show_titles_only_disable_in_search_view,
                  description: l.settings_show_titles_only_disable_in_search_view_description,
                  toggled: showTitlesOnlyDisableInSearchView,
                  onChanged: _toggleShowTitlesOnlyDisableInSearchView,
                ),
                SettingSwitchTile(
                  icon: Icons.format_color_text,
                  title: l.settings_disable_subdued_note_content_preview,
                  description: l.settings_disable_subdued_note_content_preview_description,
                  toggled: disableSubduedNoteContentPreview,
                  onChanged: _toggleDisableSubduedNoteContentPreview,
                ),
                SettingSwitchTile(
                  icon: Icons.safety_divider,
                  title: l.settings_show_separators,
                  description: l.settings_show_separators_description,
                  toggled: showSeparators,
                  onChanged: _toggleShowSeparators,
                ),
                SettingSwitchTile(
                  icon: Icons.gradient,
                  title: l.settings_show_tiles_background,
                  description: l.settings_show_tiles_background_description,
                  toggled: showTilesBackground,
                  onChanged: _toggleShowTilesBackground,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
