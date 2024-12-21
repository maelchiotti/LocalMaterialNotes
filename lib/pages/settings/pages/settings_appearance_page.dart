import 'package:dart_helper_utils/dart_helper_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:locale_names/locale_names.dart';
import '../../../common/constants/constants.dart';
import '../../../common/constants/paddings.dart';
import '../../../common/enums/localization_completion.dart';
import '../../../common/navigation/app_bars/basic_app_bar.dart';
import '../../../common/navigation/top_navigation.dart';
import '../../../common/preferences/preference_key.dart';
import '../../../common/preferences/watched_preferences.dart';
import '../../../l10n/app_localizations/app_localizations.g.dart';
import '../../../providers/preferences/preferences_provider.dart';
import '../../../utils/keys.dart';
import '../../../utils/locale_utils.dart';
import '../../../utils/theme_utils.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:restart_app/restart_app.dart';
import 'package:settings_tiles/settings_tiles.dart';
import 'package:url_launcher/url_launcher.dart';

/// Settings related to the appearance of the application.
class SettingsAppearancePage extends ConsumerStatefulWidget {
  /// Default constructor.
  const SettingsAppearancePage({super.key});

  @override
  ConsumerState<SettingsAppearancePage> createState() => _SettingsAppearancePageState();
}

class _SettingsAppearancePageState extends ConsumerState<SettingsAppearancePage> {
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
    PreferenceKey.theme.set(themeMode.name);

    ref.read(preferencesProvider.notifier).update(WatchedPreferences(themeMode: themeMode));
  }

  /// Toggles the dynamic theming.
  void _toggleDynamicTheming(bool toggled) {
    PreferenceKey.dynamicTheming.set(toggled);

    ref.read(preferencesProvider.notifier).update(WatchedPreferences(dynamicTheming: toggled));
  }

  /// Toggles the black theming.
  void _toggleBlackTheming(bool toggled) {
    PreferenceKey.blackTheming.set(toggled);

    ref.read(preferencesProvider.notifier).update(WatchedPreferences(blackTheming: toggled));
  }

  /// Toggles the setting to show background of the notes tiles.
  void _toggleShowTilesBackground(bool toggled) {
    PreferenceKey.showTilesBackground.set(toggled);

    ref.read(preferencesProvider.notifier).update(WatchedPreferences(showTilesBackground: toggled));
  }

  /// Toggles the setting to show the separators between the notes tiles.
  void _toggleShowSeparators(bool toggled) {
    PreferenceKey.showSeparators.set(toggled);

    ref.read(preferencesProvider.notifier).update(WatchedPreferences(showSeparators: toggled));
  }

  /// Toggles the setting to show background of the notes tiles.
  void _toggleShowTitlesOnly(bool toggled) {
    PreferenceKey.showTitlesOnly.set(toggled);

    ref.read(preferencesProvider.notifier).update(WatchedPreferences(showTitlesOnly: toggled));
  }

  /// Toggles the setting to show background of the notes tiles.
  void _toggleShowTitlesOnlyDisableInSearchView(bool toggled) {
    setState(() {
      PreferenceKey.showTitlesOnlyDisableInSearchView.set(toggled);
    });
  }

  @override
  Widget build(BuildContext context) {
    final locale = LocaleUtils().appLocale;
    final themeMode = ref.watch(preferencesProvider.select((preferences) => preferences.themeMode));
    final dynamicTheming = ref.watch(preferencesProvider.select((preferences) => preferences.dynamicTheming));
    final blackTheming = ref.watch(preferencesProvider.select((preferences) => preferences.blackTheming));

    final showTilesBackground = ref.watch(preferencesProvider.select((preferences) => preferences.showTilesBackground));
    final showSeparators = ref.watch(preferencesProvider.select((preferences) => preferences.showSeparators));
    final showTitlesOnly = ref.watch(preferencesProvider.select((preferences) => preferences.showTitlesOnly));
    final showTitlesOnlyDisableInSearchView = PreferenceKey.showTitlesOnlyDisableInSearchView.getPreferenceOrDefault();

    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: TopNavigation(
        key: Keys.appBarSettingsMainSubpage,
        appbar: BasicAppBar(
          title: l.navigation_settings_appearance,
          //back: true,
        ),
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
                    toggled: dynamicTheming,
                    onChanged: _toggleDynamicTheming,
                  ),
                  SettingSwitchTile(
                    enabled: isDarkMode,
                    icon: Icons.nightlight,
                    title: l.settings_black_theming,
                    description: l.settings_black_theming_description,
                    toggled: blackTheming,
                    onChanged: _toggleBlackTheming,
                  ),
                ],
              ),
              SettingSection(
                divider: null,
                title: l.settings_appearance_notes_tiles,
                tiles: [
                  SettingSwitchTile(
                    icon: Icons.gradient,
                    title: l.settings_show_tiles_background,
                    description: l.settings_show_tiles_background_description,
                    toggled: showTilesBackground,
                    onChanged: _toggleShowTilesBackground,
                  ),
                  SettingSwitchTile(
                    icon: Icons.safety_divider,
                    title: l.settings_show_separators,
                    description: l.settings_show_separators_description,
                    toggled: showSeparators,
                    onChanged: _toggleShowSeparators,
                  ),
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
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
