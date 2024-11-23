import 'package:dart_helper_utils/dart_helper_utils.dart';
import 'package:flutter/material.dart';
import 'package:localmaterialnotes/common/constants/constants.dart';
import 'package:localmaterialnotes/common/constants/paddings.dart';
import 'package:localmaterialnotes/common/navigation/app_bars/basic_app_bar.dart';
import 'package:localmaterialnotes/common/navigation/top_navigation.dart';
import 'package:localmaterialnotes/common/preferences/preference_key.dart';
import 'package:localmaterialnotes/common/preferences/preferences_utils.dart';
import 'package:localmaterialnotes/providers/notifiers.dart';
import 'package:localmaterialnotes/utils/keys.dart';
import 'package:localmaterialnotes/utils/locale_utils.dart';
import 'package:settings_tiles/settings_tiles.dart';

/// Accessibility settings.
class SettingsAccessibilityPage extends StatefulWidget {
  /// Settings related to accessibility.
  const SettingsAccessibilityPage({super.key});

  @override
  State<SettingsAccessibilityPage> createState() => _SettingsAppearancePageState();
}

class _SettingsAppearancePageState extends State<SettingsAccessibilityPage> {
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

  /// Toggles whether to use white text in dark mode.
  void _toggleUseWhiteTextDarkMode(bool toggled) {
    setState(() {
      PreferencesUtils().set<bool>(PreferenceKey.useWhiteTextDarkMode, toggled);
    });

    useWhiteTextDarkModeNotifier.value = toggled;
  }

  @override
  Widget build(BuildContext context) {
    final textScaling = PreferenceKey.textScaling.getPreferenceOrDefault<double>();
    final useWhiteTextDarkMode = PreferenceKey.useWhiteTextDarkMode.getPreferenceOrDefault<bool>();

    final darkTheme = Theme.of(context).brightness == Brightness.dark;

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
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
