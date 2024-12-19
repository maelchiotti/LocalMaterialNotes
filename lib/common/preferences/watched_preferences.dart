import 'package:flutter/material.dart';
import 'package:localmaterialnotes/common/preferences/enums/layout.dart';
import 'package:localmaterialnotes/common/preferences/enums/swipe_action.dart';
import 'package:localmaterialnotes/common/preferences/preference_key.dart';
import 'package:localmaterialnotes/utils/theme_utils.dart';

// ignore_for_file: public_member_api_docs

/// Watched preferences.
class WatchedPreferences {
  // Appearance
  late ThemeMode themeMode;
  late bool dynamicTheming;
  late bool blackTheming;
  late bool showTitlesOnly;
  late bool showTilesBackground;
  late bool showSeparators;

  // Behavior
  late ({SwipeAction right, SwipeAction left}) swipeActions;

  // Accessibility
  late double textScaling;
  late bool useWhiteTextDarkMode;
  late bool biggerTitles;

  // Notes
  late Layout layout;

  /// Watched preferences with the value passed by the argument if present, or their default value otherwise.
  WatchedPreferences({
    ThemeMode? themeMode,
    bool? dynamicTheming,
    bool? blackTheming,
    bool? showTitlesOnly,
    bool? showTilesBackground,
    bool? showSeparators,
    SwipeAction? rightSwipeAction,
    SwipeAction? leftSwipeAction,
    double? textScaling,
    bool? useWhiteTextDarkMode,
    bool? biggerTitles,
    Layout? layout,
  }) {
    this.themeMode = themeMode ?? ThemeUtils().themeMode;
    this.dynamicTheming = dynamicTheming ?? PreferenceKey.dynamicTheming.getPreferenceOrDefault();
    this.blackTheming = blackTheming ?? PreferenceKey.blackTheming.getPreferenceOrDefault();
    this.showTitlesOnly = showTitlesOnly ?? PreferenceKey.showTitlesOnly.getPreferenceOrDefault();
    this.showTilesBackground = showTilesBackground ?? PreferenceKey.showTilesBackground.getPreferenceOrDefault();
    this.showSeparators = showSeparators ?? PreferenceKey.showSeparators.getPreferenceOrDefault();

    swipeActions = (
      right: rightSwipeAction ?? SwipeAction.rightFromPreference(),
      left: leftSwipeAction ?? SwipeAction.leftFromPreference(),
    );

    this.textScaling = textScaling ?? PreferenceKey.textScaling.getPreferenceOrDefault();
    this.useWhiteTextDarkMode = useWhiteTextDarkMode ?? PreferenceKey.useWhiteTextDarkMode.getPreferenceOrDefault();
    this.biggerTitles = biggerTitles ?? PreferenceKey.biggerTitles.getPreferenceOrDefault();

    this.layout = layout ?? Layout.fromPreference();
  }
}
