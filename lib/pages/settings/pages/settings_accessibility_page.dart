import 'package:dart_helper_utils/dart_helper_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localmaterialnotes/common/constants/constants.dart';
import 'package:localmaterialnotes/common/constants/paddings.dart';
import 'package:localmaterialnotes/common/navigation/app_bars/basic_app_bar.dart';
import 'package:localmaterialnotes/common/navigation/top_navigation.dart';
import 'package:localmaterialnotes/common/preferences/preference_key.dart';
import 'package:localmaterialnotes/common/preferences/watched_preferences.dart';
import 'package:localmaterialnotes/providers/preferences/preferences_provider.dart';
import 'package:localmaterialnotes/utils/keys.dart';
import 'package:localmaterialnotes/utils/locale_utils.dart';
import 'package:settings_tiles/settings_tiles.dart';

/// Accessibility settings.
class SettingsAccessibilityPage extends ConsumerStatefulWidget {
  /// Settings related to accessibility.
  const SettingsAccessibilityPage({super.key});

  @override
  ConsumerState<SettingsAccessibilityPage> createState() => _SettingsAppearancePageState();
}

class _SettingsAppearancePageState extends ConsumerState<SettingsAccessibilityPage> {
  /// Updates the scaling of the text to the new [textScaling] when the slider of the text scaling dialog is changed.
  void _changedTextScaling(double textScaling) {
    ref.read(preferencesProvider.notifier).update(WatchedPreferences(textScaling: textScaling));
  }

  /// Sets the text scaling to the new [textScaling].
  void _submittedTextScaling(double textScaling) {
    PreferenceKey.textScaling.set(textScaling);

    ref.read(preferencesProvider.notifier).update(WatchedPreferences(textScaling: textScaling));
  }

  /// Resets the text scaling to the preference value.
  ///
  /// Called when the dialog to choose the text scaling is canceled, to revert changes made in real time
  /// when the slider is changed.
  void _canceledTextScaling() {
    ref.read(preferencesProvider.notifier).reset();
  }

  /// Toggles whether to use white text in dark mode.
  void _toggleUseWhiteTextDarkMode(bool toggled) {
    PreferenceKey.useWhiteTextDarkMode.set(toggled);

    ref.read(preferencesProvider.notifier).update(WatchedPreferences(useWhiteTextDarkMode: toggled));
  }

  /// Toggles whether to use bigger titles.
  void _toggleBiggerTitles(bool toggled) {
    PreferenceKey.biggerTitles.set(toggled);

    setState(() {
      ref.read(preferencesProvider.notifier).update(WatchedPreferences(biggerTitles: toggled));
    });
  }

  @override
  Widget build(BuildContext context) {
    final textScaling = PreferenceKey.textScaling.getPreferenceOrDefault();
    final useWhiteTextDarkMode = PreferenceKey.useWhiteTextDarkMode.getPreferenceOrDefault();
    final biggerTitles = PreferenceKey.biggerTitles.getPreferenceOrDefault();

    final darkTheme = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: TopNavigation(
        key: Keys.appBarSettingsMainSubpage,
        appbar: BasicAppBar(
          title: l.navigation_settings_accessibility,
          back: true,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: Paddings.bottomSystemUi,
          child: Column(
            children: [
              SettingSection(
                divider: null,
                tiles: [
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
                  SettingSwitchTile(
                    enabled: darkTheme,
                    icon: Icons.format_color_text,
                    title: l.settings_white_text_dark_mode,
                    description: l.settings_white_text_dark_mode_description,
                    toggled: useWhiteTextDarkMode,
                    onChanged: _toggleUseWhiteTextDarkMode,
                  ),
                  SettingSwitchTile(
                    icon: Icons.title,
                    title: l.settings_white_text_dark_mode,
                    description: l.settings_white_text_dark_mode_description,
                    toggled: biggerTitles,
                    onChanged: _toggleBiggerTitles,
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
