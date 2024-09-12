import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:localmaterialnotes/common/constants/constants.dart';
import 'package:localmaterialnotes/common/preferences/preference_key.dart';
import 'package:localmaterialnotes/common/preferences/preferences_utils.dart';
import 'package:localmaterialnotes/providers/notifiers.dart';

/// Utilities for the application's theme.
///
/// This class is a singleton.
class ThemeUtils {
  static final ThemeUtils _singleton = ThemeUtils._internal();

  /// Default constructor.
  factory ThemeUtils() {
    return _singleton;
  }

  ThemeUtils._internal();

  /// Custom primary color.
  final _customPrimaryColor = const Color(0xFF2278e9);

  /// Whether the dynamic theming is available on the device?
  late final bool isDynamicThemingAvailable;

  /// Ensures the utility is initialized.
  Future<void> ensureInitialized() async {
    isDynamicThemingAvailable = await DynamicColorPlugin.getCorePalette() != null;
  }

  /// Whether dynamic theming should be used.
  bool get useDynamicTheming {
    return PreferenceKey.dynamicTheming.getPreferenceOrDefault<bool>();
  }

  /// Whether black theming should be used.
  bool get useBlackTheming {
    return PreferenceKey.blackTheming.getPreferenceOrDefault<bool>();
  }

  /// Returns the [ThemeMode] of the application.
  ThemeMode get themeMode {
    final themeModePreference = PreferenceKey.theme.getPreferenceOrDefault<int>();

    switch (themeModePreference) {
      case 0:
        return ThemeMode.system;
      case 1:
        return ThemeMode.light;
      case 2:
        return ThemeMode.dark;
    }

    return ThemeMode.system;
  }

  /// Returns the title of the current theme mode.
  String get themeModeTitle {
    final themeModePreference = PreferenceKey.theme.getPreferenceOrDefault<int>();

    switch (themeModePreference) {
      case 0:
        return localizations.settings_theme_system;
      case 1:
        return localizations.settings_theme_light;
      case 2:
        return localizations.settings_theme_dark;
    }

    return localizations.settings_theme_system;
  }

  /// Returns the light theme.
  ///
  /// Returns a dynamic light theme if [lightDynamicColorScheme] is not null, or the custom one otherwise.
  ThemeData getLightTheme(ColorScheme? lightDynamicColorScheme) {
    final ColorScheme colorScheme;
    if (useDynamicTheming && lightDynamicColorScheme != null) {
      // TODO: remove when dynamic_colors is updated to support new roles
      // See https://github.com/material-foundation/flutter-packages/issues/582
      final temporaryColorScheme = ColorScheme.fromSeed(
        seedColor: lightDynamicColorScheme.primary,
      );

      colorScheme = lightDynamicColorScheme.copyWith(
        surfaceContainerLowest: temporaryColorScheme.surfaceContainerLowest,
        surfaceContainerLow: temporaryColorScheme.surfaceContainerLow,
        surfaceContainerHigh: temporaryColorScheme.surfaceContainerHigh,
        surfaceContainerHighest: temporaryColorScheme.surfaceContainerHighest,
      );
    } else {
      colorScheme = ColorScheme.fromSeed(
        seedColor: _customPrimaryColor,
      );
    }

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
    );
  }

  /// Returns the dark theme.
  ///
  /// Returns a dynamic dark theme if [darkDynamicColorScheme] is not null, or the custom one otherwise.
  ThemeData getDarkTheme(ColorScheme? darkDynamicColorScheme) {
    final ColorScheme colorScheme;

    if (useDynamicTheming && darkDynamicColorScheme != null) {
      // TODO: remove when dynamic_colors is updated to support new roles
      // See https://github.com/material-foundation/flutter-packages/issues/582
      final temporaryColorScheme = ColorScheme.fromSeed(
        brightness: Brightness.dark,
        seedColor: darkDynamicColorScheme.primary,
      );

      colorScheme = useBlackTheming
          ? darkDynamicColorScheme.copyWith(
              // TODO: remove when dynamic_colors is updated to support new roles
              // See https://github.com/material-foundation/flutter-packages/issues/582
              // ignore: deprecated_member_use
              background: Colors.black,
              surface: Colors.black,
              surfaceContainerLowest: temporaryColorScheme.surfaceContainerLowest,
              surfaceContainerLow: temporaryColorScheme.surfaceContainerLow,
              surfaceContainerHigh: temporaryColorScheme.surfaceContainerHigh,
              surfaceContainerHighest: temporaryColorScheme.surfaceContainerHighest,
            )
          : darkDynamicColorScheme.copyWith(
              surfaceContainerLowest: temporaryColorScheme.surfaceContainerLowest,
              surfaceContainerLow: temporaryColorScheme.surfaceContainerLow,
              surfaceContainerHigh: temporaryColorScheme.surfaceContainerHigh,
              surfaceContainerHighest: temporaryColorScheme.surfaceContainerHighest,
            );
    } else {
      colorScheme = useBlackTheming
          ? ColorScheme.fromSeed(
              brightness: Brightness.dark,
              seedColor: _customPrimaryColor,
              // TODO: remove when not required anymore, can't figure out why it's needed since it's not an issue of dynamic_colors
              // ignore: deprecated_member_use
              background: Colors.black,
              surface: Colors.black,
            )
          : ColorScheme.fromSeed(
              brightness: Brightness.dark,
              seedColor: _customPrimaryColor,
            );
    }

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
    );
  }

  /// Sets the application's theme mode to [themeMode].
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
    PreferencesUtils().set<int>(PreferenceKey.theme, value);

    themeModeNotifier.value = themeMode;
  }
}
