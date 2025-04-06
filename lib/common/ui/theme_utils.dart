import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';

import '../extensions/build_context_extension.dart';
import '../extensions/iterable_extension.dart';
import '../preferences/enums/font.dart';
import '../preferences/preference_key.dart';

/// Utilities for the application's theme.
///
/// This class is a singleton.
class ThemeUtils {
  static final ThemeUtils _singleton = ThemeUtils._internal();

  /// Default constructor.
  factory ThemeUtils() => _singleton;

  ThemeUtils._internal();

  /// Custom primary color.
  final customPrimaryColor = const Color(0xFF2278e9);

  /// Whether the dynamic theming is available on the device?
  late final bool isDynamicThemingAvailable;

  /// Ensures the utility is initialized.
  Future<void> ensureInitialized() async {
    isDynamicThemingAvailable = await DynamicColorPlugin.getCorePalette() != null;
  }

  /// Returns the [ThemeMode] of the application.
  ThemeMode get themeMode {
    final themeMode = ThemeMode.values.byNameOrNull(PreferenceKey.theme.preferenceOrDefault);

    // Reset the malformed preference to its default value
    if (themeMode == null) {
      PreferenceKey.theme.reset();

      return ThemeMode.values.byName(PreferenceKey.theme.defaultValue);
    }

    return themeMode;
  }

  /// Returns the title of the current theme mode.
  String themeModeTitle(BuildContext context) {
    switch (themeMode) {
      case ThemeMode.system:
        return context.l.settings_theme_system;
      case ThemeMode.light:
        return context.l.settings_theme_light;
      case ThemeMode.dark:
        return context.l.settings_theme_dark;
    }
  }

  /// Returns the light theme.
  ///
  /// Returns a dynamic light theme if [lightDynamicColorScheme] is not null, or the custom one otherwise.
  ThemeData getLightTheme(ColorScheme? lightDynamicColorScheme, bool dynamicTheming, Font appFont) {
    final ColorScheme colorScheme;
    if (dynamicTheming && lightDynamicColorScheme != null) {
      // TODO: remove when dynamic_colors is updated to support new roles
      // See https://github.com/material-foundation/flutter-packages/issues/582
      final temporaryColorScheme = ColorScheme.fromSeed(seedColor: lightDynamicColorScheme.primary);

      colorScheme = lightDynamicColorScheme.copyWith(
        surfaceContainerLowest: temporaryColorScheme.surfaceContainerLowest,
        surfaceContainerLow: temporaryColorScheme.surfaceContainerLow,
        surfaceContainerHigh: temporaryColorScheme.surfaceContainerHigh,
        surfaceContainerHighest: temporaryColorScheme.surfaceContainerHighest,
      );
    } else {
      colorScheme = ColorScheme.fromSeed(seedColor: customPrimaryColor);
    }

    return ThemeData(useMaterial3: true, colorScheme: colorScheme, fontFamily: appFont.familyName);
  }

  /// Returns the dark theme.
  ///
  /// Returns a dynamic dark theme if [darkDynamicColorScheme] is not null, or the custom one otherwise.
  ThemeData getDarkTheme(
    ColorScheme? darkDynamicColorScheme,
    bool dynamicTheming,
    bool blackTheming,
    Font appFont,
    bool whiteTextDarkMode,
  ) {
    final ColorScheme colorScheme;

    if (dynamicTheming && darkDynamicColorScheme != null) {
      // TODO: remove when dynamic_colors is updated to support new roles
      // See https://github.com/material-foundation/flutter-packages/issues/582
      final temporaryColorScheme = ColorScheme.fromSeed(
        brightness: Brightness.dark,
        seedColor: darkDynamicColorScheme.primary,
      );

      colorScheme =
          blackTheming
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
      colorScheme =
          blackTheming
              ? ColorScheme.fromSeed(brightness: Brightness.dark, seedColor: customPrimaryColor, surface: Colors.black)
              : ColorScheme.fromSeed(brightness: Brightness.dark, seedColor: customPrimaryColor);
    }

    final textTheme =
        whiteTextDarkMode ? Typography().white.apply(bodyColor: Colors.white, displayColor: Colors.white) : null;

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: textTheme,
      fontFamily: appFont.familyName,
    );
  }
}
