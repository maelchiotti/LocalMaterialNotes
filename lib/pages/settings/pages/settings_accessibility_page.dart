import 'package:dart_helper_utils/dart_helper_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:settings_tiles/settings_tiles.dart';

import '../../../common/constants/constants.dart';
import '../../../common/constants/paddings.dart';
import '../../../common/localization/locale_utils.dart';
import '../../../common/navigation/app_bars/basic_app_bar.dart';
import '../../../common/navigation/top_navigation.dart';
import '../../../common/preferences/preference_key.dart';
import '../../../common/preferences/watched_preferences.dart';
import '../../../common/widgets/keys.dart';
import '../../../providers/preferences/preferences_provider.dart';

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

  /// Toggles whether to use bigger titles.
  void _toggleBiggerTitles(bool toggled) {
    PreferenceKey.biggerTitles.set(toggled);

    setState(() {
      ref.read(preferencesProvider.notifier).update(WatchedPreferences(biggerTitles: toggled));
    });
  }

  /// Toggles whether to use white text in dark mode.
  void _toggleUseWhiteTextDarkMode(bool toggled) {
    PreferenceKey.useWhiteTextDarkMode.set(toggled);

    ref.read(preferencesProvider.notifier).update(WatchedPreferences(useWhiteTextDarkMode: toggled));
  }

  /// Toggles the setting to show background of the notes tiles.
  void _toggleDisableSubduedNoteContentPreview(bool toggled) {
    setState(() {
      PreferenceKey.disableSubduedNoteContentPreview.set(toggled);
    });

    ref.read(preferencesProvider.notifier).update(WatchedPreferences(disableSubduedNoteContentPreview: toggled));
  }

  @override
  Widget build(BuildContext context) {
    final textScaling = PreferenceKey.textScaling.getPreferenceOrDefault();
    final biggerTitles = PreferenceKey.biggerTitles.getPreferenceOrDefault();
    final useWhiteTextDarkMode = PreferenceKey.useWhiteTextDarkMode.getPreferenceOrDefault();
    final disableSubduedNoteContentPreview = PreferenceKey.disableSubduedNoteContentPreview.getPreferenceOrDefault();

    final darkTheme = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: TopNavigation(
        key: Keys.appBarSettingsMainSubpage,
        appbar: BasicAppBar(title: l.navigation_settings_accessibility),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: Paddings.bottomSystemUi,
          child: Column(
            children: [
              SettingSection(
                title: l.settings_accessibility_text_size,
                divider: null,
                tiles: [
                  SettingSliderTile(
                    icon: Icons.format_size,
                    title: l.settings_text_scaling,
                    value: (textScaling as num).formatAsPercentage(locale: LocaleUtils().appLocaleLanguageCode),
                    dialogTitle: l.settings_text_scaling,
                    label: (textScaling) =>
                        (textScaling as num).formatAsPercentage(locale: LocaleUtils().appLocaleLanguageCode),
                    min: 0.5,
                    max: 2.0,
                    divisions: 15,
                    initialValue: textScaling,
                    onChanged: _changedTextScaling,
                    onSubmitted: _submittedTextScaling,
                    onCanceled: _canceledTextScaling,
                  ),
                  SettingSwitchTile(
                    icon: Icons.title,
                    title: l.settings_bigger_titles,
                    description: l.settings_bigger_titles_description,
                    toggled: biggerTitles,
                    onChanged: _toggleBiggerTitles,
                  ),
                ],
              ),
              SettingSection(
                title: l.settings_accessibility_text_color,
                divider: null,
                tiles: [
                  SettingSwitchTile(
                    enabled: darkTheme,
                    icon: Icons.format_color_text,
                    title: l.settings_white_text_dark_mode,
                    description: l.settings_white_text_dark_mode_description,
                    toggled: useWhiteTextDarkMode,
                    onChanged: _toggleUseWhiteTextDarkMode,
                  ),
                  SettingSwitchTile(
                    icon: Icons.opacity,
                    title: l.settings_disable_subdued_note_content_preview,
                    description: l.settings_disable_subdued_note_content_preview_description,
                    toggled: disableSubduedNoteContentPreview,
                    onChanged: _toggleDisableSubduedNoteContentPreview,
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
