import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:localmaterialnotes/utils/constants/constants.dart';
import 'package:localmaterialnotes/utils/preferences/preference_key.dart';
import 'package:localmaterialnotes/utils/preferences/preferences_manager.dart';

class ThemeManager {
  static final ThemeManager _singleton = ThemeManager._internal();

  factory ThemeManager() {
    return _singleton;
  }

  ThemeManager._internal();

  final _customPrimaryColor = const Color(0xFF2278e9);

  late final bool isDynamicThemingAvailable;

  Future<void> init() async {
    isDynamicThemingAvailable =
        await DynamicColorPlugin.getCorePalette() != null || await DynamicColorPlugin.getAccentColor() != null;
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
    final colorScheme = useDynamicTheming && lightDynamicColorScheme != null
        ? lightDynamicColorScheme
        : ColorScheme.fromSeed(
            seedColor: _customPrimaryColor,
          );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
    );
  }

  ThemeData getDarkTheme(ColorScheme? darkDynamicColorScheme) {
    final ColorScheme colorScheme;

    if (useDynamicTheming && darkDynamicColorScheme != null) {
      colorScheme = useBlackTheming
          ? darkDynamicColorScheme.copyWith(
              // TODO: remove when dynamic_color is updated
              //  (cf. https://github.com/material-foundation/flutter-packages/issues/574
              //  and https://github.com/material-foundation/flutter-packages/issues/582)
              background: useBlackTheming ? Colors.black : null, // ignore: deprecated_member_use
              surface: useBlackTheming ? Colors.black : null,
            )
          : darkDynamicColorScheme;
    } else {
      colorScheme = useBlackTheming
          ? ColorScheme.fromSeed(
              brightness: Brightness.dark,
              seedColor: _customPrimaryColor,
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
    PreferencesManager().set<int>(PreferenceKey.theme.name, value);

    themeModeNotifier.value = themeMode;
  }
}
