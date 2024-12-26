import 'package:flutter/material.dart';

import '../../utils/theme_utils.dart';
import 'enums/bin_swipe_action.dart';
import 'enums/font.dart';
import 'enums/layout.dart';
import 'enums/note_swipe_action.dart';
import 'preference_key.dart';

// ignore_for_file: public_member_api_docs

/// Watched preferences.
class WatchedPreferences {
  // Appearance
  late ThemeMode themeMode;
  late bool dynamicTheming;
  late bool blackTheming;
  late Font appFont;
  late bool showTitlesOnly;
  late bool showTilesBackground;
  late bool showSeparators;

  // Behavior
  late ({NoteSwipeAction right, NoteSwipeAction left}) swipeActions;

  late ({BinSwipeAction right, BinSwipeAction left}) binSwipeActions;

  // Accessibility
  late double textScaling;
  late bool biggerTitles;
  late bool useWhiteTextDarkMode;
  late bool disableSubduedNoteContentPreview;

  // Notes
  late Layout layout;

  /// Watched preferences with the value passed by the argument if present, or their default value otherwise.
  WatchedPreferences({
    ThemeMode? themeMode,
    bool? dynamicTheming,
    bool? blackTheming,
    Font? appFont,
    bool? showTitlesOnly,
    bool? showTilesBackground,
    bool? showSeparators,
    NoteSwipeAction? rightSwipeAction,
    NoteSwipeAction? leftSwipeAction,
    BinSwipeAction? binRightSwipeAction,
    BinSwipeAction? binLeftSwipeAction,
    double? textScaling,
    bool? biggerTitles,
    bool? useWhiteTextDarkMode,
    bool? disableSubduedNoteContentPreview,
    Layout? layout,
  }) {
    this.themeMode = themeMode ?? ThemeUtils().themeMode;
    this.dynamicTheming = dynamicTheming ?? PreferenceKey.dynamicTheming.getPreferenceOrDefault();
    this.blackTheming = blackTheming ?? PreferenceKey.blackTheming.getPreferenceOrDefault();
    this.appFont = appFont ?? Font.appFromPreference();
    this.showTitlesOnly = showTitlesOnly ?? PreferenceKey.showTitlesOnly.getPreferenceOrDefault();
    this.showTilesBackground = showTilesBackground ?? PreferenceKey.showTilesBackground.getPreferenceOrDefault();
    this.showSeparators = showSeparators ?? PreferenceKey.showSeparators.getPreferenceOrDefault();

    swipeActions = (
      right: rightSwipeAction ?? NoteSwipeAction.rightFromPreference(),
      left: leftSwipeAction ?? NoteSwipeAction.leftFromPreference(),
    );
    binSwipeActions = (
      right: binRightSwipeAction ?? BinSwipeAction.rightFromPreference(),
      left: binLeftSwipeAction ?? BinSwipeAction.leftFromPreference(),
    );

    this.textScaling = textScaling ?? PreferenceKey.textScaling.getPreferenceOrDefault();
    this.biggerTitles = biggerTitles ?? PreferenceKey.biggerTitles.getPreferenceOrDefault();
    this.useWhiteTextDarkMode = useWhiteTextDarkMode ?? PreferenceKey.useWhiteTextDarkMode.getPreferenceOrDefault();
    this.disableSubduedNoteContentPreview =
        disableSubduedNoteContentPreview ?? PreferenceKey.disableSubduedNoteContentPreview.getPreferenceOrDefault();

    this.layout = layout ?? Layout.fromPreference();
  }
}
