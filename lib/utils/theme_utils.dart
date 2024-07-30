import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:localmaterialnotes/providers/notifiers.dart';
import 'package:localmaterialnotes/utils/constants/constants.dart';
import 'package:localmaterialnotes/utils/preferences/preference_key.dart';
import 'package:localmaterialnotes/utils/preferences/preferences_utils.dart';

class ThemeUtils {
  static final ThemeUtils _singleton = ThemeUtils._internal();

  factory ThemeUtils() {
    return _singleton;
  }

  ThemeUtils._internal();

  final _customPrimaryColor = const Color(0xFF2278e9);

  late final bool isDynamicThemingAvailable;

  Future<void> ensureInitialized() async {
    isDynamicThemingAvailable = await DynamicColorPlugin.getCorePalette() != null;
  }

  bool get useDynamicTheming {
    return PreferenceKey.dynamicTheming.getPreferenceOrDefault<bool>();
  }

  bool get useBlackTheming {
    return PreferenceKey.blackTheming.getPreferenceOrDefault<bool>();
  }

  Brightness get brightness {
    return Theme.of(navigatorKey.currentContext!).brightness;
  }

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

  String get themeModeName {
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
    PreferencesUtils().set<int>(PreferenceKey.theme.name, value);

    themeModeNotifier.value = themeMode;
  }
}
