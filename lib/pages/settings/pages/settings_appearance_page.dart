import 'package:dart_helper_utils/dart_helper_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:locale_names/locale_names.dart';
import 'package:localmaterialnotes/common/constants/constants.dart';
import 'package:localmaterialnotes/common/constants/paddings.dart';
import 'package:localmaterialnotes/common/enums/localization_completion.dart';
import 'package:localmaterialnotes/common/navigation/app_bars/basic_app_bar.dart';
import 'package:localmaterialnotes/common/navigation/top_navigation.dart';
import 'package:localmaterialnotes/common/preferences/preference_key.dart';
import 'package:localmaterialnotes/common/preferences/preferences_utils.dart';
import 'package:localmaterialnotes/l10n/app_localizations/app_localizations.g.dart';
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

  /// Sets the language to the new [locale].
  Future<void> _submittedLanguage(Locale locale) async {
    await LocaleUtils().setLocale(locale);

    // The Restart package crashes the app if used in debug mode
    if (kReleaseMode) {
      await Restart.restartApp();
    }
  }

  /// Sets the theme to the new [themeMode].
  void _submittedTheme(ThemeMode themeMode) {
    ThemeUtils().setThemeMode(themeMode);
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

  /// Updates the scaling of the text to the new [textScaling] when the slider of the text scaling dialog is changed.
  void _changedTextScaling(double textScaling) {
    textScalingNotifier.value = textScaling;
  }

  /// Sets the text scaling to the new [textScaling].
  void _submittedTextScaling(double textScaling) {
    setState(() {
      PreferencesUtils().set<double>(PreferenceKey.textScaling, textScaling);
    });

    textScalingNotifier.value = textScaling;
  }

  /// Resets the text scaling to the preference value.
  ///
  /// Called when the dialog to choose the text scaling is canceled, to revert changes made in real time
  /// when the slider is changed.
  void _canceledTextScaling() {
    textScalingNotifier.value = PreferenceKey.textScaling.getPreferenceOrDefault<double>();
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
    final locale = LocaleUtils().appLocale;
    final themeMode = ThemeUtils().themeMode;
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
        child: Padding(
          padding: Paddings.bottomSystemUi,
          child: Column(
            children: [
              SettingSection(
                divider: null,
                title: l.settings_appearance_application,
                tiles: [
                  SettingSingleOptionTile.detailed(
                    icon: Icons.language,
                    title: l.settings_language,
                    trailing: TextButton.icon(
                      onPressed: _openCrowdin,
                      label: Text(l.settings_language_contribute),
                    ),
                    value: locale.nativeDisplayLanguage.capitalizeFirstLetter,
                    dialogTitle: l.settings_language,
                    options: AppLocalizations.supportedLocales.map(
                      (locale) {
                        return (
                          value: locale,
                          title: locale.nativeDisplayLanguage.capitalizeFirstLetter,
                          subtitle: LocalizationCompletion.getFormattedPercentage(locale),
                        );
                      },
                    ).toList(),
                    initialOption: locale,
                    onSubmitted: _submittedLanguage,
                  ),
                  SettingSingleOptionTile.detailed(
                    icon: Icons.palette,
                    title: l.settings_theme,
                    value: ThemeUtils().themeModeTitle,
                    dialogTitle: l.settings_theme,
                    options: [
                      (value: ThemeMode.light, title: l.settings_theme_light, subtitle: null),
                      (value: ThemeMode.dark, title: l.settings_theme_dark, subtitle: null),
                      (value: ThemeMode.system, title: l.settings_theme_system, subtitle: null),
                    ],
                    initialOption: themeMode,
                    onSubmitted: _submittedTheme,
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
                  SettingSliderTile(
                    icon: Icons.format_size,
                    title: l.settings_text_scaling,
                    value: (textScaling as num).formatAsPercentage(locale: LocaleUtils().appLocaleLanguageCode),
                    dialogTitle: l.settings_text_scaling,
                    label: (textScaling) {
                      return (textScaling as num).formatAsPercentage(locale: LocaleUtils().appLocaleLanguageCode);
                    },
                    min: 0.5,
                    max: 2.0,
                    divisions: 15,
                    initialValue: textScaling,
                    onChanged: _changedTextScaling,
                    onSubmitted: _submittedTextScaling,
                    onCanceled: _canceledTextScaling,
                  ),
                ],
              ),
              SettingSection(
                divider: null,
                title: l.settings_appearance_notes_tiles,
                tiles: [
                  SettingSwitchTile(
                    icon: Icons.title,
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
      ),
    );
  }
}
