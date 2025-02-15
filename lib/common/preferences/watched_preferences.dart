import 'package:flutter/material.dart';

import '../../models/note/types/note_type.dart';
import '../ui/theme_utils.dart';
import 'enums/font.dart';
import 'enums/layout.dart';
import 'enums/swipe_actions/archived_swipe_action.dart';
import 'enums/swipe_actions/available_swipe_action.dart';
import 'enums/swipe_actions/deleted_swipe_action.dart';
import 'preference_key.dart';

// ignore_for_file: public_member_api_docs

/// Watched preferences.
class WatchedPreferences {
  // Appearance
  late ThemeMode themeMode;
  late bool dynamicTheming;
  late bool blackTheming;
  late Font appFont;

  // Notes types
  late List<NoteType> availableNotesTypes;

  // Notes tiles
  late bool showTilesBackground;
  late bool showSeparators;
  late bool showTitlesOnly;
  late int maximumContentPreviewLines;
  late bool showNoteTypeIcon;

  // Behavior
  late ({AvailableSwipeAction right, AvailableSwipeAction left}) availableSwipeActions;

  late ({ArchivedSwipeAction right, ArchivedSwipeAction left}) archivedSwipeActions;

  late ({DeletedSwipeAction right, DeletedSwipeAction left}) deletedSwipeActions;

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
    List<NoteType>? availableNotesTypes,
    bool? showTitlesOnly,
    bool? showTilesBackground,
    bool? showSeparators,
    int? maximumContentPreviewLines,
    bool? showNoteTypeIcon,
    AvailableSwipeAction? availableSwipeRightAction,
    AvailableSwipeAction? availableSwipeLeftAction,
    ArchivedSwipeAction? archivedSwipeRightAction,
    ArchivedSwipeAction? archivedSwipeLeftAction,
    DeletedSwipeAction? deletedSwipeRightAction,
    DeletedSwipeAction? deletedSwipeLeftAction,
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

    this.availableNotesTypes = availableNotesTypes ?? NoteType.availableTypes;

    this.showTitlesOnly = showTitlesOnly ?? PreferenceKey.showTitlesOnly.getPreferenceOrDefault();
    this.showTilesBackground = showTilesBackground ?? PreferenceKey.showTilesBackground.getPreferenceOrDefault();
    this.showSeparators = showSeparators ?? PreferenceKey.showSeparators.getPreferenceOrDefault();
    this.maximumContentPreviewLines =
        maximumContentPreviewLines ?? PreferenceKey.maximumContentPreviewLines.getPreferenceOrDefault();
    this.showNoteTypeIcon = showNoteTypeIcon ?? PreferenceKey.showNoteTypeIcon.getPreferenceOrDefault();

    availableSwipeActions = (
      right: availableSwipeRightAction ?? AvailableSwipeAction.rightFromPreference(),
      left: availableSwipeLeftAction ?? AvailableSwipeAction.leftFromPreference(),
    );
    archivedSwipeActions = (
      right: archivedSwipeRightAction ?? ArchivedSwipeAction.rightFromPreference(),
      left: archivedSwipeLeftAction ?? ArchivedSwipeAction.leftFromPreference(),
    );
    deletedSwipeActions = (
      right: deletedSwipeRightAction ?? DeletedSwipeAction.rightFromPreference(),
      left: deletedSwipeLeftAction ?? DeletedSwipeAction.leftFromPreference(),
    );

    this.textScaling = textScaling ?? PreferenceKey.textScaling.getPreferenceOrDefault();
    this.biggerTitles = biggerTitles ?? PreferenceKey.biggerTitles.getPreferenceOrDefault();
    this.useWhiteTextDarkMode = useWhiteTextDarkMode ?? PreferenceKey.useWhiteTextDarkMode.getPreferenceOrDefault();
    this.disableSubduedNoteContentPreview =
        disableSubduedNoteContentPreview ?? PreferenceKey.disableSubduedNoteContentPreview.getPreferenceOrDefault();

    this.layout = layout ?? Layout.fromPreference();
  }
}
