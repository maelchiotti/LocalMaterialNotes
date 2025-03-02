import 'package:flutter/material.dart';

import '../ui/theme_utils.dart';
import 'enums/font.dart';
import 'enums/layout.dart';
import 'preference_key.dart';

// ignore_for_file: public_member_api_docs

/// Watched preferences.
class WatchedPreferences {
  // Appearance
  late ThemeMode themeMode;
  late bool dynamicTheming;
  late bool blackTheming;
  late Font appFont;

  // Accessibility
  late double textScaling;
  late bool useWhiteTextDarkMode;

  // Notes
  late Layout layout;

  /// Watched preferences with the value passed by the argument if present, or their default value otherwise.
  WatchedPreferences({
    ThemeMode? themeMode,
    bool? dynamicTheming,
    bool? blackTheming,
    Font? appFont,
    double? textScaling,
    bool? useWhiteTextDarkMode,
    Layout? layout,
  }) {
    this.themeMode = themeMode ?? ThemeUtils().themeMode;
    this.dynamicTheming = dynamicTheming ?? PreferenceKey.dynamicTheming.preferenceOrDefault;
    this.blackTheming = blackTheming ?? PreferenceKey.blackTheming.preferenceOrDefault;
    this.appFont = appFont ?? Font.appFromPreference();

    this.textScaling = textScaling ?? PreferenceKey.textScaling.preferenceOrDefault;
    this.useWhiteTextDarkMode = useWhiteTextDarkMode ?? PreferenceKey.useWhiteTextDarkMode.preferenceOrDefault;

    this.layout = layout ?? Layout.fromPreference();
  }
}
