import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:localmaterialnotes/utils/constants/constants.dart';
import 'package:localmaterialnotes/utils/preferences/preference_key.dart';
import 'package:localmaterialnotes/utils/preferences/preferences_manager.dart';

const _customPrimaryColor = Color(0xFF2278e9);

class ThemeManager {
  static final ThemeManager _singleton = ThemeManager._internal();

  factory ThemeManager() {
    return _singleton;
  }

  ThemeManager._internal();

  late final bool isDynamicThemingAvailable;

  Future<void> init() async {
    isDynamicThemingAvailable =
        await DynamicColorPlugin.getCorePalette() != null || await DynamicColorPlugin.getAccentColor() != null;
  }

  ColorScheme get _customLightColorScheme {
    return ColorScheme.fromSeed(
      seedColor: _customPrimaryColor,
    );
  }

  ColorScheme get _customDarkColorScheme {
    return ColorScheme.fromSeed(
      brightness: Brightness.dark,
      seedColor: _customPrimaryColor,
      background: useBlackTheming ? Colors.black : null,
      surface: useBlackTheming ? Colors.black : null,
    );
  }

  bool get useDynamicTheming {
    return PreferencesManager().get<bool>(PreferenceKey.dynamicTheming) ??
        PreferenceKey.dynamicTheming.defaultValue! as bool;
  }

  bool get useBlackTheming {
    return PreferencesManager().get<bool>(PreferenceKey.blackTheming) ??
        PreferenceKey.blackTheming.defaultValue! as bool;
  }

  Brightness get brightness {
    return Theme.of(navigatorKey.currentContext!).brightness;
  }

  ThemeMode get themeMode {
    final themeModePreference = PreferencesManager().get<int>(PreferenceKey.theme);

    if (themeModePreference != null) {
      switch (themeModePreference) {
        case 0:
          return ThemeMode.system;
        case 1:
          return ThemeMode.light;
        case 2:
          return ThemeMode.dark;
      }
    }

    return ThemeMode.system;
  }

  String get themeModeName {
    final themeModePreference = PreferencesManager().get<int>(PreferenceKey.theme);

    if (themeModePreference != null) {
      switch (themeModePreference) {
        case 0:
          return localizations.settings_theme_system;
        case 1:
          return localizations.settings_theme_light;
        case 2:
          return localizations.settings_theme_dark;
      }
    }

    return localizations.settings_theme_system;
  }

  void setThemeMode(ThemeMode? themeMode) {
    if (themeMode == null) {
      return;
    }

    int value;
    switch (themeMode) {
      case ThemeMode.system:
        value = 0;
      case ThemeMode.light:
        value = 1;
      case ThemeMode.dark:
        value = 2;
    }
    PreferencesManager().set<int>(PreferenceKey.theme.name, value);

    themeModeNotifier.value = themeMode;
  }

  ThemeData getLightDynamicTheme([ColorScheme? lightDynamicColorScheme]) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: lightDynamicColorScheme != null ? lightDynamicColorScheme.harmonized() : _customLightColorScheme,
    );
  }

  ThemeData getDarkDynamicTheme([ColorScheme? darkDynamicColorScheme]) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: darkDynamicColorScheme?.copyWith(
            background: useBlackTheming ? Colors.black : null,
            surface: useBlackTheming ? Colors.black : null,
          ) ??
          _customDarkColorScheme,
    );
  }

  ThemeData get getLightCustomTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: _customLightColorScheme,
    );
  }

  ThemeData get getDarkCustomTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: _customDarkColorScheme,
    );
  }
}
